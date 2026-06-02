package com.ruoyi.ndt.orthanc;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.config.NdtProperties;

/**
 * Orthanc REST client for the NDT module.
 */
@Service
public class OrthancService
{
    private final RestClient restClient;

    @Autowired
    public OrthancService(NdtProperties properties)
    {
        this(properties, RestClient.builder());
    }

    OrthancService(NdtProperties properties, RestClient.Builder builder)
    {
        NdtProperties.Orthanc orthanc = properties.getOrthanc();
        builder.baseUrl(orthanc.getBaseUrl());
        if (StringUtils.isNotEmpty(orthanc.getUsername()))
        {
            builder.defaultHeaders(headers -> headers.setBasicAuth(orthanc.getUsername(),
                    orthanc.getPassword() == null ? "" : orthanc.getPassword()));
        }
        this.restClient = builder.build();
    }

    public JSONObject uploadInstance(byte[] content)
    {
        try
        {
            String response = restClient.post().uri("/instances")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(content).retrieve().body(String.class);
            return parseResponse(response, "上传响应");
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("Orthanc 拒绝接收 DICOM 文件", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    public JSONObject getInstance(String orthancInstanceId)
    {
        return get("/instances/{id}", orthancInstanceId, "Instance");
    }

    public JSONObject getInstanceSimplifiedTags(String orthancInstanceId)
    {
        return get("/instances/{id}/tags?simplify", orthancInstanceId, "Instance标签");
    }

    public JSONObject getSeries(String orthancSeriesId)
    {
        return get("/series/{id}", orthancSeriesId, "Series");
    }

    public JSONObject getStudy(String orthancStudyId)
    {
        return get("/studies/{id}", orthancStudyId, "Study");
    }

    public byte[] downloadInstanceFile(String orthancInstanceId)
    {
        try
        {
            return restClient.get().uri("/instances/{id}/file", orthancInstanceId)
                    .retrieve().body(byte[].class);
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("下载 Orthanc DICOM 文件失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    public JSONArray listStudies()
    {
        return listArray("/studies", "Study 列表");
    }

    public JSONArray listSeries(String orthancStudyId)
    {
        JSONObject study = getStudy(orthancStudyId);
        List<String> seriesIds = study.getList("Series", String.class);
        JSONArray result = new JSONArray();
        if (seriesIds != null)
        {
            for (String seriesId : seriesIds)
            {
                result.add(getSeries(seriesId));
            }
        }
        return result;
    }

    public JSONArray listInstances(String orthancSeriesId)
    {
        JSONObject series = getSeries(orthancSeriesId);
        List<String> instanceIds = series.getList("Instances", String.class);
        JSONArray result = new JSONArray();
        if (instanceIds != null)
        {
            for (String instanceId : instanceIds)
            {
                result.add(getInstance(instanceId));
            }
        }
        return result;
    }

    public byte[] modifyInstance(String orthancInstanceId, JSONObject tags)
    {
        try
        {
            JSONObject payload = new JSONObject();
            payload.put("Replace", tags);
            payload.put("Force", Boolean.TRUE);
            payload.put("KeepSource", Boolean.FALSE);

            byte[] modifiedDicom = restClient.post().uri("/instances/{id}/modify", orthancInstanceId)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(payload).retrieve().body(byte[].class);
            if (modifiedDicom == null || modifiedDicom.length == 0)
            {
                throw new ServiceException("Orthanc 返回的修改后 DICOM 文件为空");
            }
            return modifiedDicom;
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("生成 Orthanc 修改后 DICOM 失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    public JSONObject updateInstanceTags(String orthancInstanceId, JSONObject tags)
    {
        try
        {
            byte[] modifiedDicom = modifyInstance(orthancInstanceId, tags);
            return uploadInstance(modifiedDicom);
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("更新 Orthanc Instance 标签失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    public void deleteInstance(String orthancInstanceId)
    {
        try
        {
            restClient.delete().uri("/instances/{id}", orthancInstanceId).retrieve().toBodilessEntity();
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("删除 Orthanc Instance 失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    private JSONObject get(String path, String id, String resourceName)
    {
        try
        {
            String response = restClient.get().uri(path, id).retrieve().body(String.class);
            return parseResponse(response, resourceName + "响应");
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("读取 Orthanc " + resourceName + " 失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    private JSONArray listArray(String path, String resourceName)
    {
        try
        {
            String response = restClient.get().uri(path).retrieve().body(String.class);
            if (StringUtils.isEmpty(response))
            {
                return new JSONArray();
            }
            return JSON.parseArray(response);
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("读取 Orthanc " + resourceName + " 失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException();
        }
    }

    private JSONObject parseResponse(String response, String name)
    {
        if (StringUtils.isEmpty(response))
        {
            throw new ServiceException("Orthanc " + name + "为空");
        }
        try
        {
            return JSONObject.parseObject(response);
        }
        catch (Exception ex)
        {
            throw new ServiceException("Orthanc " + name + "无法解析");
        }
    }

    private ServiceException responseException(String message, RestClientResponseException ex)
    {
        return new ServiceException(message + "，HTTP " + ex.getStatusCode().value());
    }

    private ServiceException unavailableException()
    {
        return new ServiceException("无法连接 Orthanc 服务，请检查 ndt.orthanc.base-url 配置及服务状态");
    }
}
