package com.ruoyi.ndt.evaluation.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationSrSubmitResult;

public interface INdtEvaluationService
{
    List<NdtEvaluation> selectNdtEvaluationList(NdtEvaluation evaluation);

    NdtEvaluation selectNdtEvaluationById(Long id);

    int saveNdtEvaluation(NdtEvaluation evaluation, Long evaluatorUserId, String username);

    NdtEvaluationSrSubmitResult batchSubmitWithSr(Long taskId, List<NdtEvaluation> evaluations, MultipartFile srFile,
            String username);

    List<NdtEvaluation> selectNdtEvaluationListBySr(Long taskId, String srSopInstanceUid);

    int deleteNdtEvaluationByIds(Long[] ids);
}
