package com.ruoyi.ndt.ohif;

import static org.junit.jupiter.api.Assertions.*;
import java.util.Set;
import org.junit.jupiter.api.Test;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;

class NdtViewerControllerTest
{
    @Test void filtersArchiveStudiesByServerResolvedCompanyBeforePagination()
    {
        JSONArray source=JSON.parseArray("[{\"0020000D\":{\"Value\":[\"1.2.3\"]}},{\"0020000D\":{\"Value\":[\"1.2.4\"]}},{}]");
        JSONArray visible=NdtViewerController.filterStudies(source,Set.of("1.2.4"));
        assertEquals(1,visible.size());
        assertEquals("1.2.4",visible.getJSONObject(0).getJSONObject("0020000D").getJSONArray("Value").getString(0));
    }
    @Test void metadataBulkUrlsCannotBypassGateway()
    {
        JSONArray metadata=JSON.parseArray("[{\"7FE00010\":{\"BulkDataURI\":\"http://orthanc:8042/dicom-web/studies/1/series/2/instances/3/bulk/7fe00010\"},\"bad\":{\"BulkDataURI\":\"http://orthanc/instances/other/file\"}}]");
        NdtViewerController.rewriteBulkData(metadata);
        assertTrue(metadata.getJSONObject(0).getJSONObject("7FE00010").getString("BulkDataURI").startsWith("/ndt-api/ndt/viewer/dicom-web/studies/"));
        assertFalse(metadata.getJSONObject(0).getJSONObject("bad").containsKey("BulkDataURI"));
    }
    @Test void usesConfiguredGatewayForBulkData()
    {
        JSONArray metadata=JSON.parseArray("[{\"BulkDataURI\":\"http://orthanc/dicom-web/studies/1/series/2/instances/3/bulk/7fe00010\"}]");
        NdtViewerController.rewriteBulkData(metadata, "/custom-api/ndt/viewer/dicom-web");
        assertTrue(metadata.getJSONObject(0).getString("BulkDataURI").startsWith("/custom-api/"));
    }
}
