package com.ruoyi.ndt.config;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * NDT integration configuration.
 */
@Component
@ConfigurationProperties(prefix = "ndt")
public class NdtProperties
{
    private Orthanc orthanc = new Orthanc();

    private Ohif ohif = new Ohif();

    public Orthanc getOrthanc()
    {
        return orthanc;
    }

    public void setOrthanc(Orthanc orthanc)
    {
        this.orthanc = orthanc;
    }

    public Ohif getOhif()
    {
        return ohif;
    }

    public void setOhif(Ohif ohif)
    {
        this.ohif = ohif;
    }

    public String buildViewerUrl(String studyInstanceUid)
    {
        return buildViewerUrl(studyInstanceUid, null, null, null);
    }

    public String buildViewerUrl(String studyInstanceUid, Long taskId, Boolean canEvaluate)
    {
        return buildViewerUrl(studyInstanceUid, taskId, null, canEvaluate);
    }

    public String buildViewerUrl(String studyInstanceUid, Long taskId, Long studyId,
            Boolean canEvaluate)
    {
        String baseUrl = ohif.getViewerUrl();
        if (baseUrl == null || baseUrl.isEmpty())
        {
            return "";
        }
        String separator = baseUrl.contains("?") ? "&" : "?";
        StringBuilder builder = new StringBuilder(baseUrl)
                .append(separator)
                .append("StudyInstanceUIDs=")
                .append(URLEncoder.encode(studyInstanceUid, StandardCharsets.UTF_8));
        if (taskId != null)
        {
            builder.append("&taskId=").append(taskId);
        }
        if (studyId != null)
        {
            builder.append("&studyId=").append(studyId);
        }
        if (canEvaluate != null)
        {
            builder.append("&canEvaluate=").append(canEvaluate);
        }
        builder.append("&ruoyiApiBase=")
                .append(URLEncoder.encode(ohif.getApiBase(), StandardCharsets.UTF_8));
        return builder.toString();
    }

    public String buildViewerUrl(String studyInstanceUid, Long taskId)
    {
        return buildViewerUrl(studyInstanceUid, taskId, null, null);
    }

    public static class Orthanc
    {
        private String baseUrl;

        private String username;

        private String password;

        public String getBaseUrl()
        {
            return baseUrl;
        }

        public void setBaseUrl(String baseUrl)
        {
            this.baseUrl = baseUrl;
        }

        public String getUsername()
        {
            return username;
        }

        public void setUsername(String username)
        {
            this.username = username;
        }

        public String getPassword()
        {
            return password;
        }

        public void setPassword(String password)
        {
            this.password = password;
        }
    }

    public static class Ohif
    {
        private String apiBase = "/ndt-api";
        public String getApiBase() { return apiBase; }
        public void setApiBase(String apiBase) { this.apiBase = apiBase; }
        private String viewerUrl;

        public String getViewerUrl()
        {
            return viewerUrl;
        }

        public void setViewerUrl(String viewerUrl)
        {
            this.viewerUrl = viewerUrl;
        }
    }

}
