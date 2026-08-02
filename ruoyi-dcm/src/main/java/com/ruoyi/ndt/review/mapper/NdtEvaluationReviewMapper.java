package com.ruoyi.ndt.review.mapper;

import java.util.List;
import com.ruoyi.ndt.review.domain.NdtEvaluationReview;

public interface NdtEvaluationReviewMapper
{
    List<NdtEvaluationReview> selectByEvaluationId(Long evaluationId);
    int insert(NdtEvaluationReview review);
}
