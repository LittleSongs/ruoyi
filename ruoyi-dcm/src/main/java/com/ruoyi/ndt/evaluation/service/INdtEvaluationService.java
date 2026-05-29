package com.ruoyi.ndt.evaluation.service;

import java.util.List;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;

public interface INdtEvaluationService
{
    List<NdtEvaluation> selectNdtEvaluationList(NdtEvaluation evaluation);

    NdtEvaluation selectNdtEvaluationById(Long id);

    int saveNdtEvaluation(NdtEvaluation evaluation, Long evaluatorUserId, String username);

    int deleteNdtEvaluationByIds(Long[] ids);
}
