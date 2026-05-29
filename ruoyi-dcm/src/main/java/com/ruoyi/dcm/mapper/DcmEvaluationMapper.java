package com.ruoyi.dcm.mapper;

import java.util.List;
import com.ruoyi.dcm.domain.DcmEvaluation;

public interface DcmEvaluationMapper
{
    List<DcmEvaluation> selectDcmEvaluationList(DcmEvaluation evaluation);

    DcmEvaluation selectDcmEvaluationById(Long id);

    DcmEvaluation selectDcmEvaluationByStudyId(Long studyId);

    DcmEvaluation selectExistingDcmEvaluationByStudyId(Long studyId);

    int insertDcmEvaluation(DcmEvaluation evaluation);

    int updateDcmEvaluation(DcmEvaluation evaluation);

    int softDeleteDcmEvaluationByIds(Long[] ids);

    int softDeleteDcmEvaluationByStudyIds(Long[] studyIds);
}
