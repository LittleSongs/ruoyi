package com.ruoyi.ndt.dicom.service.impl;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.dicom.service.INdtDicomInstanceService;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;
import com.ruoyi.ndt.integrity.mapper.NdtDicomIntegrityRecordMapper;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;

@Service
public class NdtDicomInstanceServiceImpl implements INdtDicomInstanceService
{
    @Autowired
    private NdtDicomInstanceMapper dicomInstanceMapper;

    @Autowired
    private NdtDicomIntegrityRecordMapper integrityRecordMapper;

    @Autowired
    private NdtInspectionTaskMapper taskMapper;

    @Autowired
    private OrthancService orthancService;

    @Autowired
    private INdtIntegrityService integrityService;

    @Autowired
    private NdtDicomObjectRelationMapper objectRelationMapper;

    @Autowired
    private NdtAccessService accessService;

    @Autowired
    private NdtProperties properties;

    @Override
    public List<NdtDicomInstance> selectNdtDicomInstanceList(NdtDicomInstance instance)
    {
        accessService.applyTaskListScope(instance);
        return dicomInstanceMapper.selectNdtDicomInstanceList(instance);
    }

    @Override
    public NdtDicomInstance selectNdtDicomInstanceById(Long id)
    {
        NdtDicomInstance instance = dicomInstanceMapper.selectNdtDicomInstanceById(id);
        if (instance == null)
        {
            return null;
        }
        accessService.checkViewTask(instance.getTaskId());
        instance.setOhifViewerUrl(properties.buildViewerUrl(
                instance.getStudyInstanceUid(),
                instance.getTaskId(),
                String.valueOf(instance.getTaskId()),
                accessService.canEvaluateTask(instance.getTaskId())));
        return instance;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public NdtDicomUploadResult uploadDicom(Long taskId, MultipartFile file, Long userId, String username)
    {
        if (taskId == null)
        {
            throw new ServiceException("请选择检测任务");
        }
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("请选择需要上传的 DICOM 文件");
        }
        if (StringUtils.isNotEmpty(file.getOriginalFilename())
                && !file.getOriginalFilename().toLowerCase().endsWith(".dcm"))
        {
            throw new ServiceException("第一阶段仅支持 .dcm 文件上传");
        }
        accessService.checkUploadTask(taskId);
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(taskId);
        if (task == null)
        {
            throw new ServiceException("检测任务不存在或已删除");
        }

        byte[] content = readFile(file);
        String fileSha256 = integrityService.calculateSha256(content);
        JSONObject uploadResponse = orthancService.uploadInstance(content);
        String orthancInstanceId = requireValue(uploadResponse.getString("ID"), "Orthanc 上传响应缺少 Instance ID");
        JSONObject orthancInstance = orthancService.getInstance(orthancInstanceId);
        String orthancSeriesId = requireValue(orthancInstance.getString("ParentSeries"), "Orthanc Instance 缺少 ParentSeries");
        JSONObject orthancSeries = orthancService.getSeries(orthancSeriesId);
        String orthancStudyId = requireValue(orthancSeries.getString("ParentStudy"), "Orthanc Series 缺少 ParentStudy");
        JSONObject tags = orthancService.getInstanceSimplifiedTags(orthancInstanceId);

        String studyUid = requireTag(tags, "StudyInstanceUID");
        String seriesUid = requireTag(tags, "SeriesInstanceUID");
        String sopUid = requireTag(tags, "SOPInstanceUID");
        if (StringUtils.isNotEmpty(task.getStudyInstanceUid()) && !task.getStudyInstanceUid().equals(studyUid))
        {
            throw new ServiceException("当前任务已绑定其他 StudyInstanceUID，不能混入不同 Study");
        }

        NdtDicomInstance instance = upsertDicomInstance(task, file, username, userId, orthancStudyId,
                orthancSeriesId, orthancInstanceId, tags, studyUid, seriesUid, sopUid);
        upsertIntegrityRecord(instance, fileSha256, userId);
        taskMapper.updateNdtInspectionTaskStudy(taskId, studyUid, orthancStudyId,
                NdtConstants.TASK_STATUS_UPLOADED, username);

        NdtDicomUploadResult result = new NdtDicomUploadResult();
        result.setTaskId(taskId);
        result.setDicomInstanceId(instance.getId());
        result.setStudyInstanceUid(studyUid);
        result.setSeriesInstanceUid(seriesUid);
        result.setSopInstanceUid(sopUid);
        result.setOrthancStudyId(orthancStudyId);
        result.setOrthancSeriesId(orthancSeriesId);
        result.setOrthancInstanceId(orthancInstanceId);
        result.setFileSha256(fileSha256);
        result.setOhifViewerUrl(properties.buildViewerUrl(studyUid));
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public NdtDicomUploadResult replaceDicomTags(Long id, JSONObject tags, Long userId, String username)
    {
        if (id == null)
        {
            throw new ServiceException("DICOM实例ID不能为空");
        }
        if (tags == null || tags.isEmpty())
        {
            throw new ServiceException("请提供需要替换的 DICOM 标签");
        }

        NdtDicomInstance original = dicomInstanceMapper.selectNdtDicomInstanceById(id);
        if (original == null)
        {
            throw new ServiceException("DICOM实例不存在");
        }
        accessService.checkViewTask(original.getTaskId());

        String oldOrthancInstanceId = original.getOrthancInstanceId();
        String oldSopUid = original.getSopInstanceUid();
        String oldStudyUid = original.getStudyInstanceUid();
        String oldSeriesUid = original.getSeriesInstanceUid();
        String oldOrthancSeriesId = original.getOrthancSeriesId();
        String oldOrthancStudyId = original.getOrthancStudyId();

        byte[] modifiedDicom = orthancService.modifyInstance(oldOrthancInstanceId, tags);
        orthancService.deleteInstance(oldOrthancInstanceId);
        JSONObject uploadResponse = orthancService.uploadInstance(modifiedDicom);
        String newOrthancInstanceId = requireValue(uploadResponse.getString("ID"), "Orthanc 重新上传响应缺少 Instance ID");
        JSONObject orthancInstance = orthancService.getInstance(newOrthancInstanceId);
        String newOrthancSeriesId = requireValue(orthancInstance.getString("ParentSeries"), "Orthanc Instance 缺少 ParentSeries");
        JSONObject orthancSeries = orthancService.getSeries(newOrthancSeriesId);
        String newOrthancStudyId = requireValue(orthancSeries.getString("ParentStudy"), "Orthanc Series 缺少 ParentStudy");
        JSONObject mergedTags = orthancService.getInstanceSimplifiedTags(newOrthancInstanceId);

        String newStudyUid = requireTag(mergedTags, "StudyInstanceUID");
        String newSeriesUid = requireTag(mergedTags, "SeriesInstanceUID");
        String newSopUid = requireTag(mergedTags, "SOPInstanceUID");
        if (StringUtils.isNotEmpty(original.getStudyInstanceUid()) && !original.getStudyInstanceUid().equals(newStudyUid))
        {
            throw new ServiceException("当前替换后的 DICOM 属于不同 StudyInstanceUID，不允许直接替换当前业务实例");
        }

        String newFileSha256 = integrityService.calculateSha256(modifiedDicom);
        NdtDicomInstance updated = updateDicomIndexes(original, userId, username, newOrthancStudyId, newOrthancSeriesId,
                newOrthancInstanceId, mergedTags, newStudyUid, newSeriesUid, newSopUid);
        updateIntegrityRecordAndRelations(original, updated, oldOrthancInstanceId, oldSopUid, oldStudyUid,
                oldSeriesUid, oldOrthancStudyId, oldOrthancSeriesId, userId, newFileSha256);

        NdtDicomUploadResult result = new NdtDicomUploadResult();
        result.setTaskId(updated.getTaskId());
        result.setDicomInstanceId(updated.getId());
        result.setStudyInstanceUid(updated.getStudyInstanceUid());
        result.setSeriesInstanceUid(updated.getSeriesInstanceUid());
        result.setSopInstanceUid(updated.getSopInstanceUid());
        result.setOrthancStudyId(updated.getOrthancStudyId());
        result.setOrthancSeriesId(updated.getOrthancSeriesId());
        result.setOrthancInstanceId(updated.getOrthancInstanceId());
        result.setFileSha256(newFileSha256);
        result.setOhifViewerUrl(properties.buildViewerUrl(updated.getStudyInstanceUid()));
        return result;
    }

    @Override
    public byte[] downloadDicom(Long id)
    {
        NdtDicomInstance instance = dicomInstanceMapper.selectNdtDicomInstanceById(id);
        if (instance == null)
        {
            throw new ServiceException("DICOM实例不存在");
        }
        accessService.checkViewTask(instance.getTaskId());
        return orthancService.downloadInstanceFile(instance.getOrthancInstanceId());
    }

    @Override
    public String getOhifViewerUrl(Long id)
    {
        NdtDicomInstance instance = dicomInstanceMapper.selectNdtDicomInstanceById(id);
        if (instance == null)
        {
            throw new ServiceException("DICOM实例不存在");
        }
        accessService.checkViewTask(instance.getTaskId());
        return buildOhifViewerUrl(instance.getStudyInstanceUid(), instance.getTaskId());
    }

    @Override
    public String buildOhifViewerUrl(String studyInstanceUid, Long taskId)
    {
        if (StringUtils.isEmpty(studyInstanceUid))
        {
            throw new ServiceException("StudyInstanceUID不能为空");
        }
        return properties.buildViewerUrl(studyInstanceUid, taskId);
    }

    private byte[] readFile(MultipartFile file)
    {
        try
        {
            return file.getBytes();
        }
        catch (IOException ex)
        {
            throw new ServiceException("读取上传的 DICOM 文件失败");
        }
    }

    private NdtDicomInstance upsertDicomInstance(NdtInspectionTask task, MultipartFile file, String username,
            Long userId, String orthancStudyId, String orthancSeriesId, String orthancInstanceId,
            JSONObject tags, String studyUid, String seriesUid, String sopUid)
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
        instance.setModality(tag(tags, "Modality"));
        instance.setSeriesNumber(tag(tags, "SeriesNumber"));
        instance.setInstanceNumber(tag(tags, "InstanceNumber"));
        instance.setSeriesDescription(tag(tags, "SeriesDescription"));
        instance.setSopClassUid(tag(tags, "SOPClassUID"));
        instance.setIsOriginal(NdtConstants.YES);
        instance.setFileName(file.getOriginalFilename());
        instance.setFileSize(file.getSize());
        instance.setUploadUserId(userId);
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

    private NdtDicomInstance updateDicomIndexes(NdtDicomInstance original, Long userId, String username,
            String orthancStudyId, String orthancSeriesId, String orthancInstanceId, JSONObject tags,
            String studyUid, String seriesUid, String sopUid)
    {
        NdtDicomInstance updated = dicomInstanceMapper.selectNdtDicomInstanceById(original.getId());
        if (updated == null)
        {
            throw new ServiceException("DICOM实例不存在，无法更新业务索引");
        }
        updated.setStudyInstanceUid(studyUid);
        updated.setSeriesInstanceUid(seriesUid);
        updated.setSopInstanceUid(sopUid);
        updated.setOrthancStudyId(orthancStudyId);
        updated.setOrthancSeriesId(orthancSeriesId);
        updated.setOrthancInstanceId(orthancInstanceId);
        updated.setModality(tag(tags, "Modality"));
        updated.setSeriesNumber(tag(tags, "SeriesNumber"));
        updated.setInstanceNumber(tag(tags, "InstanceNumber"));
        updated.setSeriesDescription(tag(tags, "SeriesDescription"));
        updated.setSopClassUid(tag(tags, "SOPClassUID"));
        updated.setUploadUserId(userId);
        updated.setUploadTime(new Date());
        updated.setIntegrityStatus(NdtConstants.INTEGRITY_STATUS_UNKNOWN);
        updated.setUpdateBy(username);
        dicomInstanceMapper.updateNdtDicomInstance(updated);
        return updated;
    }

    private void updateIntegrityRecordAndRelations(NdtDicomInstance original, NdtDicomInstance updated,
            String oldOrthancInstanceId, String oldSopUid, String oldStudyUid, String oldSeriesUid,
            String oldOrthancStudyId, String oldOrthancSeriesId, Long userId, String newFileSha256)
    {
        NdtDicomIntegrityRecord existing = integrityRecordMapper.selectNdtDicomIntegrityRecordBySopUid(oldSopUid);
        if (existing != null)
        {
            existing.setStudyInstanceUid(updated.getStudyInstanceUid());
            existing.setSeriesInstanceUid(updated.getSeriesInstanceUid());
            existing.setSopInstanceUid(updated.getSopInstanceUid());
            existing.setOrthancInstanceId(updated.getOrthancInstanceId());
            existing.setFileSha256(newFileSha256);
            existing.setImportUserId(userId);
            existing.setImportTime(new Date());
            existing.setVerifyStatus(NdtConstants.INTEGRITY_STATUS_UNKNOWN);
            integrityRecordMapper.updateNdtDicomIntegrityRecord(existing);
        }

        NdtDicomObjectRelation relationQuery = new NdtDicomObjectRelation();
        relationQuery.setTaskId(updated.getTaskId());
        relationQuery.setSourceSopInstanceUid(oldSopUid);
        List<NdtDicomObjectRelation> relations = objectRelationMapper.selectNdtDicomObjectRelationList(relationQuery);
        if (relations != null)
        {
            for (NdtDicomObjectRelation relation : relations)
            {
                relation.setOrthancInstanceId(updated.getOrthancInstanceId());
                relation.setRelatedSopInstanceUid(updated.getSopInstanceUid());
                relation.setRelatedSeriesInstanceUid(updated.getSeriesInstanceUid());
                relation.setCreateTime(new Date());
                objectRelationMapper.insertNdtDicomObjectRelation(relation);
            }
        }
    }

    private void upsertIntegrityRecord(NdtDicomInstance instance, String fileSha256, Long userId)
    {
        NdtDicomIntegrityRecord existing = integrityRecordMapper
                .selectNdtDicomIntegrityRecordBySopUid(instance.getSopInstanceUid());
        NdtDicomIntegrityRecord record = existing == null ? new NdtDicomIntegrityRecord() : existing;
        record.setStudyInstanceUid(instance.getStudyInstanceUid());
        record.setSeriesInstanceUid(instance.getSeriesInstanceUid());
        record.setSopInstanceUid(instance.getSopInstanceUid());
        record.setOrthancInstanceId(instance.getOrthancInstanceId());
        record.setFileSha256(fileSha256);
        record.setImportUserId(userId);
        record.setImportTime(new Date());
        record.setVerifyStatus(NdtConstants.INTEGRITY_STATUS_UNKNOWN);
        // TODO: Parse PixelData with dcm4che/pydicom and fill pixelDataSha256 in a later phase.
        if (existing == null)
        {
            integrityRecordMapper.insertNdtDicomIntegrityRecord(record);
        }
        else
        {
            integrityRecordMapper.updateNdtDicomIntegrityRecord(record);
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
            throw new ServiceException(message + "；文件可能已归档到 Orthanc，但未写入业务索引");
        }
        return value;
    }
}
