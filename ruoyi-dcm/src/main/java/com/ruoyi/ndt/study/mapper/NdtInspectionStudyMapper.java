package com.ruoyi.ndt.study.mapper;

import java.util.List;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;

public interface NdtInspectionStudyMapper
{
    List<NdtInspectionStudy> selectList(NdtInspectionStudy query);
    List<NdtInspectionStudy> selectByWorkpieceId(Long workpieceId);
    NdtInspectionStudy selectById(Long id);
    NdtInspectionStudy selectByStudyInstanceUid(String studyInstanceUid);
    int insert(NdtInspectionStudy study);
}
