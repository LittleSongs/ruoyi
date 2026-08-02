package com.ruoyi.ndt.review.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.common.NdtBusinessRules;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.review.domain.NdtEvaluationReview;
import com.ruoyi.ndt.review.dto.NdtEvaluationReviewCreateDto;
import com.ruoyi.ndt.review.mapper.NdtEvaluationReviewMapper;
import com.ruoyi.ndt.review.service.INdtEvaluationReviewService;
import com.ruoyi.ndt.security.NdtAccessService;

@Service
public class NdtEvaluationReviewServiceImpl implements INdtEvaluationReviewService
{
    private final NdtEvaluationReviewMapper mapper;
    private final NdtEvaluationMapper evaluationMapper;
    private final NdtAccessService access;
    public NdtEvaluationReviewServiceImpl(NdtEvaluationReviewMapper mapper,
            NdtEvaluationMapper evaluationMapper, NdtAccessService access)
    {
        this.mapper = mapper; this.evaluationMapper = evaluationMapper; this.access = access;
    }
    public List<NdtEvaluationReview> selectByEvaluationId(Long evaluationId)
    {
        NdtEvaluation evaluation = require(evaluationId); access.checkViewTask(evaluation.getTaskId());
        return mapper.selectByEvaluationId(evaluationId);
    }
    public int insert(NdtEvaluationReviewCreateDto dto, Long userId, String username)
    {
        NdtBusinessRules.requireReviewResult(dto.getReviewResult());
        NdtEvaluation evaluation = require(dto.getEvaluationId());
        access.checkEvaluateTask(evaluation.getTaskId());
        if (!NdtConstants.EVALUATION_STATUS_SUBMITTED.equals(evaluation.getStatus()))
            throw new ServiceException("只能复核已提交的评定");
        NdtEvaluationReview review = new NdtEvaluationReview();
        review.setEvaluationId(dto.getEvaluationId()); review.setReviewResult(dto.getReviewResult());
        review.setReviewComment(dto.getReviewComment()); review.setReviewerId(userId);
        review.setReviewTime(new Date()); review.setCreateBy(username); return mapper.insert(review);
    }
    private NdtEvaluation require(Long id)
    {
        NdtEvaluation value = evaluationMapper.selectById(id);
        if (value == null) throw new ServiceException("评定不存在"); return value;
    }
}
