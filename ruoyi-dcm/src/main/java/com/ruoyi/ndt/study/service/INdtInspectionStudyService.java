package com.ruoyi.ndt.study.service;

import java.util.List;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.vo.NdtStudyViewerContextVo;

public interface INdtInspectionStudyService
{
    List<NdtInspectionStudy> selectList(NdtInspectionStudy query);
    NdtInspectionStudy selectById(Long id);
    NdtStudyViewerContextVo getViewerContextByStudyInstanceUid(String studyInstanceUid);
    String getOhifViewerUrl(Long id);
}
