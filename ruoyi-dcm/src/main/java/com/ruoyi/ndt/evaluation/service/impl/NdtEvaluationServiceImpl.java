package com.ruoyi.ndt.evaluation.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;

@Service
public class NdtEvaluationServiceImpl implements INdtEvaluationService
{
    @Autowired
    private NdtEvaluationMapper evaluationMapper;

    @Autowired
    private NdtInspectionTaskMapper taskMapper;

    @Autowired
    private NdtAccessService accessService;

    @Override
    public List<NdtEvaluation> selectNdtEvaluationList(NdtEvaluation evaluation)
    {
        accessService.applyTaskListScope(evaluation);
        return evaluationMapper.selectNdtEvaluationList(evaluation);
    }

    @Override
    public NdtEvaluation selectNdtEvaluationById(Long id)
    {
        NdtEvaluation evaluation = evaluationMapper.selectNdtEvaluationById(id);
        if (evaluation != null)
        {
            accessService.checkViewTask(evaluation.getTaskId());
        }
        return evaluation;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveNdtEvaluation(NdtEvaluation evaluation, Long evaluatorUserId, String username)
    {
        if (evaluation.getTaskId() == null)
        {
            throw new ServiceException("检测任务不能为空");
        }
        accessService.checkEvaluateTask(evaluation.getTaskId());
        if (StringUtils.isEmpty(evaluation.getStatus()))
        {
            evaluation.setStatus(NdtConstants.EVALUATION_STATUS_DRAFT);
        }
        if (!NdtConstants.EVALUATION_STATUS_DRAFT.equals(evaluation.getStatus())
                && !NdtConstants.EVALUATION_STATUS_SUBMITTED.equals(evaluation.getStatus()))
        {
            throw new ServiceException("评定状态仅支持 DRAFT 或 SUBMITTED");
        }
        evaluation.setEvaluatorUserId(evaluatorUserId);
        evaluation.setEvaluateTime(NdtConstants.EVALUATION_STATUS_SUBMITTED.equals(evaluation.getStatus()) ? new Date() : null);
        evaluation.setUpdateBy(username);
        evaluation.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        int rows;
        if (evaluation.getId() == null)
        {
            evaluation.setCreateBy(username);
            rows = evaluationMapper.insertNdtEvaluation(evaluation);
        }
        else
        {
            rows = evaluationMapper.updateNdtEvaluation(evaluation);
        }
        taskMapper.updateNdtInspectionTaskStatus(evaluation.getTaskId(),
                NdtConstants.EVALUATION_STATUS_SUBMITTED.equals(evaluation.getStatus())
                        ? NdtConstants.TASK_STATUS_EVALUATED : NdtConstants.TASK_STATUS_EVALUATING,
                username);
        return rows;
    }

    @Override
    public int deleteNdtEvaluationByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            NdtEvaluation evaluation = evaluationMapper.selectNdtEvaluationById(id);
            if (evaluation != null)
            {
                accessService.checkEvaluateTask(evaluation.getTaskId());
            }
        }
        return evaluationMapper.softDeleteNdtEvaluationByIds(ids);
    }
}
