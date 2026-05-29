package com.ruoyi.ndt.inspector.service;

import java.util.List;
import com.ruoyi.ndt.inspector.domain.NdtInspectorProfile;

public interface INdtInspectorProfileService
{
    List<NdtInspectorProfile> selectNdtInspectorProfileList(NdtInspectorProfile profile);

    NdtInspectorProfile selectNdtInspectorProfileById(Long id);

    NdtInspectorProfile selectNdtInspectorProfileByUserId(Long userId);

    int saveNdtInspectorProfile(NdtInspectorProfile profile, String username);

    int deleteNdtInspectorProfileByIds(Long[] ids);
}
