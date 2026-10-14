package com.ruoyi.ndt.ohif;

import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.util.UriComponentsBuilder;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.customer.mapper.NdtCustomerMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;

/** The only DICOMweb endpoint exposed to the customer portal. No STOW or archive management. */
@RestController
@RequestMapping("/ndt/viewer")
public class NdtViewerController
{
    private static final Pattern STUDY_PATH = Pattern.compile("/studies/([0-9]+(?:\\.[0-9]+)*)(?:/.*)?");
    private static final Pattern READ_PATH = Pattern.compile(
        "/studies/[0-9.]+(?:/(?:metadata|rendered)|/series/[0-9.]+(?:/(?:metadata|rendered)|/instances(?:/[0-9.]+(?:/(?:metadata|rendered)|/frames/[0-9,]+(?:/rendered)?|/bulk/[A-Za-z0-9/]+)?)?)?|/series|/instances)?");
    private final NdtAccessService access;
    private final NdtInspectionStudyMapper studies;
    private final NdtCustomerMapper companies;
    private final RestClient orthanc;
    private final String orthancBase;
    private final String viewerGateway;

    public NdtViewerController(NdtAccessService access, NdtInspectionStudyMapper studies,
            NdtCustomerMapper companies, NdtProperties properties)
    {
        this.access=access; this.studies=studies; this.companies=companies;
        this.viewerGateway=properties.getOhif().getApiBase().replaceAll("/+$", "")+"/ndt/viewer/dicom-web";
        this.orthancBase=properties.getOrthanc().getBaseUrl().replaceAll("/+$", "");
        RestClient.Builder builder=RestClient.builder();
        String username=properties.getOrthanc().getUsername();
        if (username != null && !username.isEmpty()) builder.defaultHeaders(h ->
            h.setBasicAuth(username, Optional.ofNullable(properties.getOrthanc().getPassword()).orElse("")));
        orthanc=builder.build();
    }

    @GetMapping("/session")
    public AjaxResult session()
    {
        boolean customer=access.isCustomerAccount();
        Long companyId=customer ? access.getActiveCustomerId() : null;
        if (customer && companyId == null) return AjaxResult.error(403, "客户账号、客户角色或所属公司已失效");
        Map<String,Object> info=new LinkedHashMap<>();
        info.put("userId",SecurityUtils.getUserId());
        info.put("userName",SecurityUtils.getUsername());
        info.put("customer",customer);
        info.put("customerId",companyId);
        info.put("customerName",companyId == null ? null : companies.selectById(companyId).getName());
        info.put("canUseLocalTools",true);
        info.put("canCreateContent",!customer);
        return AjaxResult.success(info);
    }

    @GetMapping("/dicom-web/**")
    public ResponseEntity<byte[]> dicomWeb(HttpServletRequest request)
    {
        String prefix=request.getContextPath()+"/ndt/viewer/dicom-web";
        String path=request.getRequestURI().substring(prefix.length());
        boolean listing=path.equals("/studies");
        if (!listing && !READ_PATH.matcher(path).matches()) return error(400, "不支持的DICOM读取路径");
        if (!listing)
        {
            java.util.regex.Matcher match=STUDY_PATH.matcher(path);
            if (!match.matches()) return error(400, "必须指定Study");
            NdtInspectionStudy study=studies.selectByStudyInstanceUid(match.group(1));
            if (study == null || !access.canViewTask(study.getTaskId())) return error(403, "无权访问该Study");
        }
        Set<String> visible=listing ? visibleStudyUIDs() : Collections.emptySet();
        if (listing && visible.isEmpty()) return dicomJson(new JSONArray());
        UriComponentsBuilder uri=UriComponentsBuilder.fromUriString(orthancBase+"/dicom-web"+path);
        for (Map.Entry<String,String[]> query : request.getParameterMap().entrySet())
        {
            // Authorization is only read from the header; client filters never establish ownership.
            if (query.getKey().equalsIgnoreCase("token")) continue;
            if (listing && (query.getKey().equalsIgnoreCase("limit") || query.getKey().equalsIgnoreCase("offset"))) continue;
            for (String value : query.getValue()) uri.queryParam(query.getKey(), value);
        }
        String accept=request.getHeader(HttpHeaders.ACCEPT);
        try
        {
            ResponseEntity<byte[]> upstream=orthanc.get().uri(uri.build().encode().toUri())
                .header(HttpHeaders.ACCEPT,listing ? "application/dicom+json" : (accept == null ? "*/*" : accept))
                .retrieve().toEntity(byte[].class);
            byte[] body=upstream.getBody();
            String contentType=upstream.getHeaders().getFirst(HttpHeaders.CONTENT_TYPE);
            if (listing || (contentType != null && contentType.contains("json")))
            {
                JSONArray items=body == null || body.length == 0 ? new JSONArray()
                    : JSON.parseArray(new String(body,StandardCharsets.UTF_8));
                if (listing)
                {
                    items=filterStudies(items,visible);
                    int offset=boundedNumber(request.getParameter("offset"),0);
                    int limit=boundedNumber(request.getParameter("limit"),items.size());
                    items=new JSONArray(items.subList(Math.min(offset,items.size()),
                        (int)Math.min((long)items.size(),(long)offset+limit)));
                }
                rewriteBulkData(items, viewerGateway);
                return dicomJson(items);
            }
            HttpHeaders headers=new HttpHeaders();
            if (contentType != null) headers.set(HttpHeaders.CONTENT_TYPE,contentType);
            headers.setCacheControl("no-store");
            return new ResponseEntity<>(body,headers,upstream.getStatusCode());
        }
        catch (RestClientResponseException ex) { return error(ex.getStatusCode().value(),"归档服务读取失败"); }
        catch (ResourceAccessException ex) { return error(502,"归档服务暂不可用"); }
        catch (IllegalArgumentException ex) { return error(400,"DICOM查询参数无效"); }
    }

    private Set<String> visibleStudyUIDs()
    {
        NdtInspectionStudy query=new NdtInspectionStudy();
        access.applyTaskListScope(query);
        return studies.selectList(query).stream().map(NdtInspectionStudy::getStudyInstanceUid).collect(Collectors.toSet());
    }

    static JSONArray filterStudies(JSONArray source, Set<String> visible)
    {
        JSONArray result=new JSONArray();
        for (Object value : source)
        {
            JSONObject row=(JSONObject)value;
            JSONObject tag=row.getJSONObject("0020000D");
            JSONArray values=tag == null ? null : tag.getJSONArray("Value");
            if (values != null && !values.isEmpty() && visible.contains(values.getString(0))) result.add(row);
        }
        return result;
    }

    static void rewriteBulkData(Object value)
    {
        rewriteBulkData(value, "/ndt-api/ndt/viewer/dicom-web");
    }

    static void rewriteBulkData(Object value, String gateway)
    {
        if (value instanceof JSONObject)
        {
            JSONObject object=(JSONObject)value;
            String bulk=object.getString("BulkDataURI");
            if (bulk != null)
            {
                int index=bulk.indexOf("/studies/");
                if (index >= 0) object.put("BulkDataURI",gateway+bulk.substring(index));
                else object.remove("BulkDataURI"); // Never expose an unguarded archive URL.
            }
            object.values().forEach(child -> rewriteBulkData(child, gateway));
        }
        else if (value instanceof JSONArray) ((JSONArray)value).forEach(child -> rewriteBulkData(child, gateway));
    }

    private static int boundedNumber(String value,int fallback)
    {
        if (value == null) return fallback;
        int result=Integer.parseInt(value);
        if (result < 0) throw new IllegalArgumentException();
        return result;
    }

    private static ResponseEntity<byte[]> dicomJson(JSONArray body)
    {
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE,"application/dicom+json")
            .header(HttpHeaders.CACHE_CONTROL,"no-store").body(JSON.toJSONBytes(body));
    }
    private static ResponseEntity<byte[]> error(int status,String message)
    {
        return ResponseEntity.status(status).contentType(MediaType.APPLICATION_JSON)
            .body(JSON.toJSONBytes(AjaxResult.error(status,message)));
    }
}
