package com.ruoyi.ndt.evaluation.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtBusinessRules;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.defect.domain.NdtDefect;
import com.ruoyi.ndt.defect.mapper.NdtDefectMapper;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.service.INdtDicomObjectService;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.mapper.NdtWorkpieceMapper;

@Service
public class NdtEvaluationServiceImpl implements INdtEvaluationService
{
    private final NdtEvaluationMapper mapper;
    private final NdtDefectMapper defectMapper;
    private final NdtWorkpieceMapper workpieceMapper;
    private final INdtDicomObjectService objectService;
    private final NdtAccessService access;
    public NdtEvaluationServiceImpl(NdtEvaluationMapper mapper, NdtDefectMapper defectMapper,
            NdtWorkpieceMapper workpieceMapper, INdtDicomObjectService objectService, NdtAccessService access)
    {
        this.mapper = mapper; this.defectMapper = defectMapper; this.workpieceMapper = workpieceMapper;
        this.objectService = objectService; this.access = access;
    }
    public List<NdtEvaluation> selectList(NdtEvaluation query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }
    public NdtEvaluation selectById(Long id)
    {
        NdtEvaluation value = require(id); access.checkViewTask(value.getTaskId()); return value;
    }
    public int insert(NdtEvaluation value, Long userId, String username)
    {
        validate(value); access.checkEvaluateTask(resolveTaskId(value));
        if (StringUtils.isEmpty(value.getStatus())) value.setStatus(NdtConstants.EVALUATION_STATUS_DRAFT);
        value.setEvaluatorId(userId); value.setCreateBy(username); value.setUpdateBy(username);
        return mapper.insert(value);
    }
    public int update(NdtEvaluation value, String username)
    {
        NdtEvaluation old = require(value.getId()); access.checkEvaluateTask(old.getTaskId());
        if (!NdtConstants.EVALUATION_STATUS_DRAFT.equals(old.getStatus()))
            throw new ServiceException("已提交评定不能修改");
        value.setUpdateBy(username); return mapper.update(value);
    }
    public int submit(Long id, Long userId, String username)
    {
        NdtEvaluation value = require(id); access.checkEvaluateTask(value.getTaskId());
        if (!NdtConstants.EVALUATION_STATUS_DRAFT.equals(value.getStatus()))
            throw new ServiceException("评定已经提交");
        return mapper.updateStatus(id, NdtConstants.EVALUATION_STATUS_SUBMITTED, userId, username);
    }
    @Transactional(rollbackFor = Exception.class)
    public NdtDicomObject submitWithSr(Long id, Long sourceObjectId, MultipartFile file,
            Long userId, String username)
    {
        NdtEvaluation evaluation = require(id);
        NdtDicomObject source = objectService.selectById(sourceObjectId);
        if (!evaluation.getTaskId().equals(source.getTaskId()))
            throw new ServiceException("SR来源对象与评定必须属于同一个任务");
        submit(id, userId, username);
        return objectService.uploadDerivedDicom(sourceObjectId, NdtConstants.OBJECT_TYPE_SR,
                NdtConstants.RELATION_TYPE_GENERATED_FROM, file, userId, username);
    }
    public int deleteByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            NdtEvaluation value = require(id); access.checkEvaluateTask(value.getTaskId());
            if (!NdtConstants.EVALUATION_STATUS_DRAFT.equals(value.getStatus()))
                throw new ServiceException("已提交评定不能删除");
        }
        return mapper.softDeleteByIds(ids);
    }
    private NdtEvaluation require(Long id)
    {
        NdtEvaluation value = mapper.selectById(id);
        if (value == null) throw new ServiceException("评定不存在"); return value;
    }
    private void validate(NdtEvaluation value)
    {
        NdtBusinessRules.requireEvaluationTarget(value.getEvaluationType(), value.getDefectId(), value.getWorkpieceId());
    }
    private Long resolveTaskId(NdtEvaluation value)
    {
        if (value.getDefectId() != null)
        {
            NdtDefect defect = defectMapper.selectById(value.getDefectId());
            if (defect == null) throw new ServiceException("缺陷不存在");
            return defect.getTaskId();
        }
        NdtWorkpiece workpiece = workpieceMapper.selectById(value.getWorkpieceId());
        if (workpiece == null) throw new ServiceException("工件不存在");
        return workpiece.getTaskId();
    }
}
