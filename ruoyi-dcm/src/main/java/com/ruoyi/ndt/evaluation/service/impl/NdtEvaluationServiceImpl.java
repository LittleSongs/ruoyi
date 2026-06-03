package com.ruoyi.ndt.evaluation.service.impl;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluationSrSubmitResult;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
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

    @Autowired
    private OrthancService orthancService;

    @Autowired
    private NdtDicomInstanceMapper dicomInstanceMapper;

    @Autowired
    private NdtDicomObjectRelationMapper objectRelationMapper;

    @Autowired
    private INdtIntegrityService integrityService;

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
        if (evaluatorUserId != null)
        {
            accessService.checkEvaluateTask(evaluation.getTaskId());
        }
        if (StringUtils.isEmpty(evaluation.getStatus()))
        {
            evaluation.setStatus(NdtConstants.EVALUATION_STATUS_DRAFT);
        }
        if (!NdtConstants.EVALUATION_STATUS_DRAFT.equals(evaluation.getStatus())
                && !NdtConstants.EVALUATION_STATUS_SUBMITTED.equals(evaluation.getStatus()))
        {
            throw new ServiceException("评定状态仅支持 DRAFT 或 SUBMITTED");
        }
        if (StringUtils.isNotBlank(evaluation.getStudyInstanceUid())
                && StringUtils.isNotBlank(evaluation.getSeriesInstanceUid())
                && StringUtils.isNotBlank(evaluation.getSopInstanceUid()))
        {
            // keep incoming UIDs
        }
        else
        {
            throw new ServiceException("评定图像UID不能为空");
        }
        evaluation.setEvaluatorUserId(evaluatorUserId);
        evaluation.setEvaluateTime(new Date());
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
    @Transactional(rollbackFor = Exception.class)
    public NdtEvaluationSrSubmitResult batchSubmitWithSr(Long taskId, List<NdtEvaluation> evaluations,
            MultipartFile srFile, String username)
    {
        if (taskId == null)
        {
            throw new ServiceException("检测任务不能为空");
        }
        if (evaluations == null || evaluations.isEmpty())
        {
            throw new ServiceException("缺陷评定列表不能为空");
        }
        if (srFile == null || srFile.isEmpty())
        {
            throw new ServiceException("DICOM SR文件不能为空");
        }
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(taskId);
        if (task == null)
        {
            throw new ServiceException("检测任务不存在或已删除");
        }

        SrUploadContext srContext = uploadSrAndIndex(task, srFile, username);
        List<NdtEvaluation> savedEvaluations = new ArrayList<>();
        for (NdtEvaluation evaluation : evaluations)
        {
            evaluation.setTaskId(taskId);
            evaluation.setStatus(NdtConstants.EVALUATION_STATUS_SUBMITTED);
            saveBatchEvaluation(evaluation, username);
            savedEvaluations.add(evaluation);
            insertSrRelation(taskId, evaluation, srContext);
        }
        taskMapper.updateNdtInspectionTaskStatus(taskId, NdtConstants.TASK_STATUS_EVALUATED, username);

        NdtEvaluationSrSubmitResult result = new NdtEvaluationSrSubmitResult();
        result.setEvaluations(savedEvaluations);
        result.setSrReport(srContext.result);
        return result;
    }

    @Override
    public List<NdtEvaluation> selectNdtEvaluationListBySr(Long taskId, String srSopInstanceUid)
    {
        if (taskId == null || StringUtils.isEmpty(srSopInstanceUid))
        {
            return new ArrayList<>();
        }
        NdtDicomObjectRelation query = new NdtDicomObjectRelation();
        query.setTaskId(taskId);
        query.setRelatedType(NdtConstants.RELATED_TYPE_SR);
        query.setRelatedSopInstanceUid(srSopInstanceUid);
        List<NdtDicomObjectRelation> relations = objectRelationMapper.selectNdtDicomObjectRelationList(query);
        List<NdtEvaluation> evaluations = new ArrayList<>();
        if (relations != null)
        {
            for (NdtDicomObjectRelation relation : relations)
            {
                if (relation.getEvaluationId() != null)
                {
                    NdtEvaluation evaluation = evaluationMapper.selectNdtEvaluationById(relation.getEvaluationId());
                    if (evaluation != null)
                    {
                        evaluations.add(evaluation);
                    }
                }
            }
        }
        return evaluations;
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

    private void saveBatchEvaluation(NdtEvaluation evaluation, String username)
    {
        validateEvaluationImage(evaluation);
        evaluation.setEvaluatorUserId(null);
        evaluation.setEvaluateTime(new Date());
        evaluation.setUpdateBy(username);
        evaluation.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        if (evaluation.getId() == null)
        {
            evaluation.setCreateBy(username);
            evaluationMapper.insertNdtEvaluation(evaluation);
        }
        else
        {
            evaluationMapper.updateNdtEvaluation(evaluation);
        }
    }

    private SrUploadContext uploadSrAndIndex(NdtInspectionTask task, MultipartFile srFile, String username)
    {
        byte[] content = readFile(srFile);
        String fileSha256 = integrityService.calculateSha256(content);
        JSONObject uploadResponse = orthancService.uploadInstance(content);
        String orthancInstanceId = requireValue(uploadResponse.getString("ID"), "Orthanc 上传响应缺少 Instance ID");
        JSONObject orthancInstance = orthancService.getInstance(orthancInstanceId);
        String orthancSeriesId = requireValue(orthancInstance.getString("ParentSeries"),
                "Orthanc Instance 缺少 ParentSeries");
        JSONObject orthancSeries = orthancService.getSeries(orthancSeriesId);
        String orthancStudyId = requireValue(orthancSeries.getString("ParentStudy"),
                "Orthanc Series 缺少 ParentStudy");
        JSONObject tags = orthancService.getInstanceSimplifiedTags(orthancInstanceId);
        String studyUid = requireTag(tags, "StudyInstanceUID");
        String seriesUid = requireTag(tags, "SeriesInstanceUID");
        String sopUid = requireTag(tags, "SOPInstanceUID");

        NdtDicomInstance instance = upsertSrInstance(task, srFile, username, orthancStudyId, orthancSeriesId,
                orthancInstanceId, tags, studyUid, seriesUid, sopUid);

        NdtDicomUploadResult result = new NdtDicomUploadResult();
        result.setTaskId(task.getId());
        result.setDicomInstanceId(instance.getId());
        result.setStudyInstanceUid(studyUid);
        result.setSeriesInstanceUid(seriesUid);
        result.setSopInstanceUid(sopUid);
        result.setOrthancStudyId(orthancStudyId);
        result.setOrthancSeriesId(orthancSeriesId);
        result.setOrthancInstanceId(orthancInstanceId);
        result.setFileSha256(fileSha256);

        SrUploadContext context = new SrUploadContext();
        context.orthancInstanceId = orthancInstanceId;
        context.seriesInstanceUid = seriesUid;
        context.sopInstanceUid = sopUid;
        context.result = result;
        return context;
    }

    private NdtDicomInstance upsertSrInstance(NdtInspectionTask task, MultipartFile srFile, String username,
            String orthancStudyId, String orthancSeriesId, String orthancInstanceId, JSONObject tags,
            String studyUid, String seriesUid, String sopUid)
    {
        NdtDicomInstance existing = dicomInstanceMapper.selectNdtDicomInstanceBySopUid(sopUid);
        NdtDicomInstance instance = existing == null ? new NdtDicomInstance() : existing;
        instance.setTaskId(task.getId());
        instance.setWorkpieceName(task.getWorkpieceName());
        instance.setCustomerDeptId(task.getCustomerDeptId());
        instance.setStudyInstanceUid(studyUid);
        instance.setSeriesInstanceUid(seriesUid);
        instance.setSopInstanceUid(sopUid);
        instance.setOrthancStudyId(orthancStudyId);
        instance.setOrthancSeriesId(orthancSeriesId);
        instance.setOrthancInstanceId(orthancInstanceId);
        instance.setModality(defaultValue(tag(tags, "Modality"), "SR"));
        instance.setSeriesNumber(tag(tags, "SeriesNumber"));
        instance.setInstanceNumber(tag(tags, "InstanceNumber"));
        instance.setSeriesDescription(defaultValue(tag(tags, "SeriesDescription"), "NDT Defect Structured Report"));
        instance.setSopClassUid(tag(tags, "SOPClassUID"));
        instance.setIsOriginal(NdtConstants.NO);
        instance.setFileName(defaultValue(srFile.getOriginalFilename(), "ndt-evaluation-sr.dcm"));
        instance.setFileSize(srFile.getSize());
        instance.setUploadUserId(null);
        instance.setUploadTime(new Date());
        instance.setIntegrityStatus(NdtConstants.INTEGRITY_STATUS_UNKNOWN);
        instance.setUpdateBy(username);
        instance.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        if (existing == null)
        {
            instance.setCreateBy(username);
            dicomInstanceMapper.insertNdtDicomInstance(instance);
        }
        else
        {
            dicomInstanceMapper.updateNdtDicomInstance(instance);
        }
        return instance;
    }

    private void insertSrRelation(Long taskId, NdtEvaluation evaluation, SrUploadContext srContext)
    {
        NdtDicomObjectRelation relation = new NdtDicomObjectRelation();
        relation.setTaskId(taskId);
        relation.setSourceSopInstanceUid(evaluation.getSopInstanceUid());
        relation.setRelatedSopInstanceUid(srContext.sopInstanceUid);
        relation.setRelatedSeriesInstanceUid(srContext.seriesInstanceUid);
        relation.setRelatedType(NdtConstants.RELATED_TYPE_SR);
        relation.setOrthancInstanceId(srContext.orthancInstanceId);
        relation.setEvaluationId(evaluation.getId());
        objectRelationMapper.insertNdtDicomObjectRelation(relation);
    }

    private void validateEvaluationImage(NdtEvaluation evaluation)
    {
        if (StringUtils.isBlank(evaluation.getStudyInstanceUid())
                || StringUtils.isBlank(evaluation.getSeriesInstanceUid())
                || StringUtils.isBlank(evaluation.getSopInstanceUid()))
        {
            throw new ServiceException("评定图像UID不能为空");
        }
    }

    private byte[] readFile(MultipartFile file)
    {
        try
        {
            return file.getBytes();
        }
        catch (Exception ex)
        {
            throw new ServiceException("读取上传的 DICOM SR 文件失败");
        }
    }

    private String requireTag(JSONObject tags, String name)
    {
        return requireValue(tag(tags, name), "DICOM 标签缺少关键字段 " + name);
    }

    private String tag(JSONObject tags, String name)
    {
        return tags == null ? null : tags.getString(name);
    }

    private String requireValue(String value, String message)
    {
        if (StringUtils.isEmpty(value))
        {
            throw new ServiceException(message + "；SR文件可能已归档到 Orthanc，但未写入业务索引");
        }
        return value;
    }

    private String defaultValue(String value, String fallback)
    {
        return StringUtils.isEmpty(value) ? fallback : value;
    }

    private static class SrUploadContext
    {
        private String orthancInstanceId;
        private String seriesInstanceUid;
        private String sopInstanceUid;
        private NdtDicomUploadResult result;
    }
}
