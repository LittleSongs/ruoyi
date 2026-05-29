package com.ruoyi.dcm.service;

import java.util.List;
import com.ruoyi.dcm.domain.DcmEvaluation;

public interface IDcmEvaluationService
{
    List<DcmEvaluation> selectDcmEvaluationList(DcmEvaluation evaluation);

    DcmEvaluation selectDcmEvaluationById(Long id);

    DcmEvaluation selectDcmEvaluationByStudyId(Long studyId);

    int saveDcmEvaluation(DcmEvaluation evaluation, Long evaluatorId, String evaluatorName);

    int deleteDcmEvaluationByIds(Long[] ids, String updateBy);
}
