package com.ruoyi.dcm.service;

import java.util.List;
import com.ruoyi.dcm.domain.DcmStudy;

public interface IDcmStudyService
{
    List<DcmStudy> selectDcmStudyList(DcmStudy study);

    DcmStudy selectDcmStudyById(Long id);

    int deleteDcmStudyByIds(Long[] ids);
}
