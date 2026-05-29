package com.ruoyi.dcm.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.constants.DcmConstants;
import com.ruoyi.dcm.domain.DcmEvaluation;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.mapper.DcmEvaluationMapper;
import com.ruoyi.dcm.mapper.DcmStudyMapper;
import com.ruoyi.dcm.service.IDcmEvaluationService;

@Service
public class DcmEvaluationServiceImpl implements IDcmEvaluationService
{
    @Autowired
    private DcmEvaluationMapper evaluationMapper;

    @Autowired
    private DcmStudyMapper studyMapper;

    @Override
    public List<DcmEvaluation> selectDcmEvaluationList(DcmEvaluation evaluation)
    {
        return evaluationMapper.selectDcmEvaluationList(evaluation);
    }

    @Override
    public DcmEvaluation selectDcmEvaluationById(Long id)
    {
        return evaluationMapper.selectDcmEvaluationById(id);
    }

    @Override
    public DcmEvaluation selectDcmEvaluationByStudyId(Long studyId)
    {
        return evaluationMapper.selectDcmEvaluationByStudyId(studyId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int saveDcmEvaluation(DcmEvaluation evaluation, Long evaluatorId, String evaluatorName)
    {
        if (evaluation.getStudyId() == null)
        {
            throw new ServiceException("请选择需要评定的 Study");
        }
        DcmStudy study = studyMapper.selectDcmStudyById(evaluation.getStudyId());
        if (study == null)
        {
            throw new ServiceException("Study 不存在或已删除");
        }
        String status = evaluation.getEvaluationStatus();
        if (StringUtils.isEmpty(status))
        {
            status = DcmConstants.EVALUATION_STATUS_DRAFT;
            evaluation.setEvaluationStatus(status);
        }
        if (!DcmConstants.EVALUATION_STATUS_DRAFT.equals(status)
                && !DcmConstants.EVALUATION_STATUS_SUBMITTED.equals(status))
        {
            throw new ServiceException("评定状态仅支持 DRAFT 或 SUBMITTED");
        }

        evaluation.setEvaluatorId(evaluatorId);
        evaluation.setEvaluatorName(evaluatorName);
        evaluation.setUpdateBy(evaluatorName);
        evaluation.setDelFlag(DcmConstants.DEL_FLAG_NORMAL);
        evaluation.setEvaluationTime(DcmConstants.EVALUATION_STATUS_SUBMITTED.equals(status) ? new Date() : null);
        DcmEvaluation existing = evaluationMapper.selectExistingDcmEvaluationByStudyId(evaluation.getStudyId());
        int rows;
        if (existing == null)
        {
            evaluation.setCreateBy(evaluatorName);
            rows = evaluationMapper.insertDcmEvaluation(evaluation);
        }
        else
        {
            evaluation.setId(existing.getId());
            rows = evaluationMapper.updateDcmEvaluation(evaluation);
        }

        String studyStatus = DcmConstants.EVALUATION_STATUS_SUBMITTED.equals(status)
                ? DcmConstants.STUDY_STATUS_EVALUATED : DcmConstants.STUDY_STATUS_EVALUATING;
        studyMapper.updateDcmStudyStatus(evaluation.getStudyId(), studyStatus, evaluatorName);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteDcmEvaluationByIds(Long[] ids, String updateBy)
    {
        for (Long id : ids)
        {
            DcmEvaluation evaluation = evaluationMapper.selectDcmEvaluationById(id);
            if (evaluation != null)
            {
                studyMapper.updateDcmStudyStatus(evaluation.getStudyId(), DcmConstants.STUDY_STATUS_UPLOADED, updateBy);
            }
        }
        return evaluationMapper.softDeleteDcmEvaluationByIds(ids);
    }
}
