package com.ruoyi.ndt.inspector.mapper;

import java.util.List;
import com.ruoyi.ndt.inspector.domain.NdtInspectorProfile;

public interface NdtInspectorProfileMapper
{
    List<NdtInspectorProfile> selectNdtInspectorProfileList(NdtInspectorProfile profile);

    NdtInspectorProfile selectNdtInspectorProfileById(Long id);

    NdtInspectorProfile selectNdtInspectorProfileByUserId(Long userId);

    int insertNdtInspectorProfile(NdtInspectorProfile profile);

    int updateNdtInspectorProfile(NdtInspectorProfile profile);

    int softDeleteNdtInspectorProfileByIds(Long[] ids);
}
