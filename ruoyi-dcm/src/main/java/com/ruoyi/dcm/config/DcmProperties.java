package com.ruoyi.dcm.config;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * DICOM integration configuration.
 */
@Component
@ConfigurationProperties(prefix = "dcm")
public class DcmProperties
{
    private Orthanc orthanc = new Orthanc();

    private Ohif ohif = new Ohif();

    private Validation validation = new Validation();

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

    public Validation getValidation()
    {
        return validation;
    }

    public void setValidation(Validation validation)
    {
        this.validation = validation;
    }

    public String buildViewerUrl(String studyInstanceUid)
    {
        String baseUrl = ohif.getViewerUrl();
        String separator = baseUrl != null && baseUrl.contains("?") ? "&" : "?";
        return baseUrl + separator + "StudyInstanceUIDs="
                + URLEncoder.encode(studyInstanceUid, StandardCharsets.UTF_8);
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

    public static class Validation
    {
        private boolean officialEnabled = true;
        private String officialCommand = "validate_iods";
        private int officialTimeoutSeconds = 60;

        public boolean isOfficialEnabled()
        {
            return officialEnabled;
        }

        public void setOfficialEnabled(boolean officialEnabled)
        {
            this.officialEnabled = officialEnabled;
        }

        public String getOfficialCommand()
        {
            return officialCommand;
        }

        public void setOfficialCommand(String officialCommand)
        {
            this.officialCommand = officialCommand;
        }

        public int getOfficialTimeoutSeconds()
        {
            return officialTimeoutSeconds;
        }

        public void setOfficialTimeoutSeconds(int officialTimeoutSeconds)
        {
            this.officialTimeoutSeconds = officialTimeoutSeconds;
        }
    }
}
