package com.ruoyi.ndt.config;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class NdtPropertiesTest
{
    @Test
    void viewerUrlCarriesTheDatabaseStudyId()
    {
        NdtProperties properties = new NdtProperties();
        properties.getOhif().setViewerUrl("http://localhost:3000/industrial-viewer");

        String url = properties.buildViewerUrl("1.2.840", 3L, 1L, true);

        assertEquals("http://localhost:3000/industrial-viewer?StudyInstanceUIDs=1.2.840"
                + "&taskId=3&studyId=1&canEvaluate=true"
                + "&ruoyiApiBase=http%3A%2F%2Flocalhost%3A3000", url);
    }
}
