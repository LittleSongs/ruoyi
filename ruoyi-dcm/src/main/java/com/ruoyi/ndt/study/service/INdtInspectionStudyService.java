package com.ruoyi.ndt.study.service;

import java.util.List;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;

public interface INdtInspectionStudyService
{
    List<NdtInspectionStudy> selectList(NdtInspectionStudy query);
    NdtInspectionStudy selectById(Long id);
    String getOhifViewerUrl(Long id);
}
