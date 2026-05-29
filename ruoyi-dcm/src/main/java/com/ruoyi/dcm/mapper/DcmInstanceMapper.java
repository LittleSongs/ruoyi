package com.ruoyi.dcm.mapper;

import java.util.List;
import com.ruoyi.dcm.domain.DcmInstance;

public interface DcmInstanceMapper
{
    List<DcmInstance> selectDcmInstanceList(DcmInstance instance);

    DcmInstance selectDcmInstanceByUid(String sopInstanceUid);

    int insertDcmInstance(DcmInstance instance);

    int updateDcmInstance(DcmInstance instance);

    int softDeleteDcmInstanceByStudyId(Long studyId);

    int softDeleteDcmInstanceByStudyIds(Long[] studyIds);
}
