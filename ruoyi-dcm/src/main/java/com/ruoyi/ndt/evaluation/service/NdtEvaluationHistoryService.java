package com.ruoyi.ndt.evaluation.service;

import com.ruoyi.ndt.evaluation.domain.NdtEvaluationHistoryResponse;

public interface NdtEvaluationHistoryService
{
    NdtEvaluationHistoryResponse selectHistory(Long taskId, String sopInstanceUid);
}
