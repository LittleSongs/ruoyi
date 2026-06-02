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
        return properties.buildViewerUrl(instance.getStudyInstanceUid());
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
