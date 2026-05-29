package com.ruoyi.dcm.config;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class DcmPropertiesTest
{
    @Test
    void buildsEncodedViewerUrlFromConfiguration()
    {
        DcmProperties properties = new DcmProperties();
        properties.getOhif().setViewerUrl("http://localhost:3000/viewer");

        String url = properties.buildViewerUrl("1.2.840 test/value");

        assertEquals("http://localhost:3000/viewer?StudyInstanceUIDs=1.2.840+test%2Fvalue", url);
    }
}
