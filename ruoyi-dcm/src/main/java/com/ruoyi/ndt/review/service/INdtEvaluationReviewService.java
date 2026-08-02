package com.ruoyi.ndt.review.service;

import java.util.List;
import com.ruoyi.ndt.review.domain.NdtEvaluationReview;
import com.ruoyi.ndt.review.dto.NdtEvaluationReviewCreateDto;

public interface INdtEvaluationReviewService
{
    List<NdtEvaluationReview> selectByEvaluationId(Long evaluationId);
    int insert(NdtEvaluationReviewCreateDto dto, Long userId, String username);
}
