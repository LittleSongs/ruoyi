package com.ruoyi.ndt;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class NdtCustomerPortalBoundaryTest
{
    @Test void onlyExplicitReadEndpointsAreAllowed()
    {
        assertTrue(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/ndt/viewer/session"));
        assertTrue(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/ndt/viewer/dicom-web/studies/1/series"));
        assertTrue(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/ndt/task/1/object-tree"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/system/user/list"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/getRouters"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("GET","/ndt/orthanc/tree"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("POST","/ndt/evaluation/1/submit-with-sr"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("POST","/ndt/report"));
        assertFalse(NdtCustomerAccessConfig.isAllowedCustomerRequest("DELETE","/ndt/viewer/dicom-web/studies/1"));
    }
}
