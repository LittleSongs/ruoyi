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

    private Security security = new Security();

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

    public Security getSecurity()
    {
        return security;
    }

    public void setSecurity(Security security)
    {
        this.security = security;
    }

    public String buildViewerUrl(String studyInstanceUid)
    {
        return buildViewerUrl(studyInstanceUid, null, null, null);
    }

    public String buildViewerUrl(String studyInstanceUid, Long taskId, String token, Boolean canEvaluate)
    {
        String baseUrl = ohif.getViewerUrl();
        String separator = baseUrl != null && baseUrl.contains("?") ? "&" : "?";
        StringBuilder builder = new StringBuilder(baseUrl)
                .append(separator)
                .append("StudyInstanceUIDs=")
                .append(URLEncoder.encode(studyInstanceUid, StandardCharsets.UTF_8));
        if (taskId != null)
        {
            builder.append("&taskId=").append(taskId);
        }
        if (token != null && !token.isEmpty())
        {
            builder.append("&token=").append(URLEncoder.encode(token, StandardCharsets.UTF_8));
        }
        if (canEvaluate != null)
        {
            builder.append("&canEvaluate=").append(canEvaluate);
        }
        //这里的ruoyiApiBase=http://localhost:3000，后续要改掉，不能这么设计，现在这样是为了在 ohif 前端项目中可以跳转。
        builder.append("&ruoyiApiBase=")
                .append(URLEncoder.encode("http://localhost:3000", StandardCharsets.UTF_8));
        return builder.toString();
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

    public static class Security
    {
        private Long companyRootDeptId;

        public Long getCompanyRootDeptId()
        {
            return companyRootDeptId;
        }

        public void setCompanyRootDeptId(Long companyRootDeptId)
        {
            this.companyRootDeptId = companyRootDeptId;
        }
    }
}
