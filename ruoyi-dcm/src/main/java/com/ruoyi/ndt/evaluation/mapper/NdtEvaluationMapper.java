package com.ruoyi.ndt.evaluation.mapper;

import java.util.List;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;

public interface NdtEvaluationMapper
{
    List<NdtEvaluation> selectNdtEvaluationList(NdtEvaluation evaluation);

    NdtEvaluation selectNdtEvaluationById(Long id);

    int insertNdtEvaluation(NdtEvaluation evaluation);

    int updateNdtEvaluation(NdtEvaluation evaluation);

    int softDeleteNdtEvaluationByIds(Long[] ids);
}
