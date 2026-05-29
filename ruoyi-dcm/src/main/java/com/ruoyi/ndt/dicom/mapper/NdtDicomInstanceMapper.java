package com.ruoyi.ndt.dicom.mapper;

import java.util.List;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;

public interface NdtDicomInstanceMapper
{
    List<NdtDicomInstance> selectNdtDicomInstanceList(NdtDicomInstance instance);

    NdtDicomInstance selectNdtDicomInstanceById(Long id);

    NdtDicomInstance selectNdtDicomInstanceBySopUid(String sopInstanceUid);

    int insertNdtDicomInstance(NdtDicomInstance instance);

    int updateNdtDicomInstance(NdtDicomInstance instance);
}
