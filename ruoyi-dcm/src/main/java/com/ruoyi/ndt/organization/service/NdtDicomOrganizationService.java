package com.ruoyi.ndt.organization.service;

import java.util.Collection;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeResponse;

public interface NdtDicomOrganizationService
{
    void registerOriginal(Long taskId, Long dicomInstanceId);
    void registerRelated(Long taskId, Long dicomInstanceId, Collection<String> sourceSopUids,
            String objectType);
    NdtObjectTreeResponse selectObjectTree(Long taskId);
}
