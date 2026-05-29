package com.ruoyi.dcm.service;

import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.config.DcmProperties;

/**
 * Orthanc REST client.
 */
@Service
public class DcmOrthancService
{
    private final RestClient restClient;

    @Autowired
    public DcmOrthancService(DcmProperties properties)
    {
        this(properties, RestClient.builder());
    }

    DcmOrthancService(DcmProperties properties, RestClient.Builder builder)
    {
        DcmProperties.Orthanc orthanc = properties.getOrthanc();
        builder.baseUrl(orthanc.getBaseUrl());
        if (StringUtils.isNotEmpty(orthanc.getUsername()))
        {
            builder.defaultHeaders(headers -> headers.setBasicAuth(orthanc.getUsername(),
                    orthanc.getPassword() == null ? "" : orthanc.getPassword()));
        }
        this.restClient = builder.build();
    }

    public JSONObject uploadInstance(MultipartFile file)
    {
        try
        {
            String response = restClient.post().uri("/instances")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(file.getBytes()).retrieve().body(String.class);
            return parseResponse(response, "上传响应");
        }
        catch (IOException ex)
        {
            throw new ServiceException("读取上传的 DCM 文件失败");
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("Orthanc 拒绝接收 DCM 文件", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException(ex);
        }
    }

    public JSONObject getInstance(String orthancInstanceId)
    {
        return get("/instances/{id}", orthancInstanceId, "Instance");
    }

    public JSONObject getInstanceSimplifiedTags(String orthancInstanceId)
    {
        return get("/instances/{id}/tags?simplify", orthancInstanceId, "Instance 标签");
    }

    public JSONObject getStudy(String orthancStudyId)
    {
        return get("/studies/{id}", orthancStudyId, "Study");
    }

    public JSONObject getSeries(String orthancSeriesId)
    {
        return get("/series/{id}", orthancSeriesId, "Series");
    }

    private JSONObject get(String path, String id, String resourceName)
    {
        try
        {
            String response = restClient.get().uri(path, id).retrieve().body(String.class);
            return parseResponse(response, resourceName + " 响应");
        }
        catch (RestClientResponseException ex)
        {
            throw responseException("读取 Orthanc " + resourceName + " 失败", ex);
        }
        catch (ResourceAccessException ex)
        {
            throw unavailableException(ex);
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

    private ServiceException unavailableException(ResourceAccessException ex)
    {
        return new ServiceException("无法连接 Orthanc 服务，请检查 dcm.orthanc.base-url 配置及服务状态");
    }
}
