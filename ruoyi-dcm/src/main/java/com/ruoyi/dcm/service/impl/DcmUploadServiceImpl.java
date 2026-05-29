package com.ruoyi.dcm.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.config.DcmProperties;
import com.ruoyi.dcm.constants.DcmConstants;
import com.ruoyi.dcm.domain.DcmInstance;
import com.ruoyi.dcm.domain.DcmSeries;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.domain.DcmUploadResult;
import com.ruoyi.dcm.mapper.DcmInstanceMapper;
import com.ruoyi.dcm.mapper.DcmSeriesMapper;
import com.ruoyi.dcm.mapper.DcmStudyMapper;
import com.ruoyi.dcm.service.DcmOrthancService;
import com.ruoyi.dcm.service.IDcmUploadService;

/**
 * Uploads a DICOM object and synchronizes its entire Orthanc Study index.
 */
@Service
public class DcmUploadServiceImpl implements IDcmUploadService
{
    @Autowired
    private DcmOrthancService orthancService;

    @Autowired
    private DcmProperties properties;

    @Autowired
    private DcmStudyMapper studyMapper;

    @Autowired
    private DcmSeriesMapper seriesMapper;

    @Autowired
    private DcmInstanceMapper instanceMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public DcmUploadResult uploadAndSync(MultipartFile file, Long uploadUserId, String uploadUserName)
    {
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("请选择需要上传的 DCM 文件");
        }

        JSONObject uploadResponse = orthancService.uploadInstance(file);
        String uploadedInstanceId = requireValue(uploadResponse.getString("ID"), "Orthanc 上传响应缺少 Instance ID");
        JSONObject uploadedInstance = orthancService.getInstance(uploadedInstanceId);
        String parentSeriesId = requireValue(uploadedInstance.getString("ParentSeries"),
                "Orthanc Instance 缺少 ParentSeries");
        JSONObject uploadedSeries = orthancService.getSeries(parentSeriesId);
        String orthancStudyId = requireValue(uploadedSeries.getString("ParentStudy"),
                "Orthanc Series 缺少 ParentStudy");
        JSONObject orthancStudy = orthancService.getStudy(orthancStudyId);
        JSONObject uploadedTags = orthancService.getInstanceSimplifiedTags(uploadedInstanceId);

        String studyUid = requireTag(uploadedTags, "StudyInstanceUID");
        String uploadedSeriesUid = requireTag(uploadedTags, "SeriesInstanceUID");
        String uploadedSopUid = requireTag(uploadedTags, "SOPInstanceUID");
        JSONArray orthancSeriesIds = orthancStudy.getJSONArray("Series");
        if (orthancSeriesIds == null || orthancSeriesIds.isEmpty())
        {
            throw new ServiceException("Orthanc Study 不包含可同步的 Series");
        }

        int totalInstanceCount = countInstances(orthancSeriesIds);
        DcmStudy study = upsertStudy(orthancStudyId, studyUid, uploadedTags, orthancSeriesIds.size(),
                totalInstanceCount, uploadUserId, uploadUserName);

        // A resync mirrors Orthanc's current hierarchy and restores only objects still present there.
        seriesMapper.softDeleteDcmSeriesByStudyId(study.getId());
        instanceMapper.softDeleteDcmInstanceByStudyId(study.getId());
        syncSeriesAndInstances(study.getId(), orthancSeriesIds, uploadUserName);

        DcmUploadResult result = new DcmUploadResult();
        result.setStudyId(study.getId());
        result.setOrthancStudyId(orthancStudyId);
        result.setStudyInstanceUid(studyUid);
        result.setSeriesInstanceUid(uploadedSeriesUid);
        result.setSopInstanceUid(uploadedSopUid);
        result.setPatientName(study.getPatientName());
        result.setStudyDescription(study.getStudyDescription());
        result.setOhifViewerUrl(properties.buildViewerUrl(studyUid));
        return result;
    }

    private int countInstances(JSONArray seriesIds)
    {
        int count = 0;
        for (Object value : seriesIds)
        {
            JSONObject series = orthancService.getSeries(String.valueOf(value));
            JSONArray instances = series.getJSONArray("Instances");
            if (instances != null)
            {
                count += instances.size();
            }
        }
        return count;
    }

    private DcmStudy upsertStudy(String orthancStudyId, String studyUid, JSONObject tags, int seriesCount,
            int instanceCount, Long userId, String userName)
    {
        DcmStudy existing = studyMapper.selectDcmStudyByUid(studyUid);
        DcmStudy study = existing == null ? new DcmStudy() : existing;
        boolean restore = existing == null || DcmConstants.DEL_FLAG_DELETED.equals(existing.getDelFlag());

        study.setOrthancStudyId(orthancStudyId);
        study.setStudyInstanceUid(studyUid);
        study.setStudyDescription(tag(tags, "StudyDescription"));
        study.setStudyDate(tag(tags, "StudyDate"));
        study.setAccessionNumber(tag(tags, "AccessionNumber"));
        study.setPatientId(tag(tags, "PatientID"));
        study.setPatientName(tag(tags, "PatientName"));
        study.setPatientSex(tag(tags, "PatientSex"));
        study.setPatientBirthDate(tag(tags, "PatientBirthDate"));
        study.setModality(tag(tags, "Modality"));
        study.setSeriesCount(seriesCount);
        study.setInstanceCount(instanceCount);
        study.setUploadUserId(userId);
        study.setUploadUserName(userName);
        study.setDelFlag(DcmConstants.DEL_FLAG_NORMAL);
        study.setUpdateBy(userName);
        if (restore)
        {
            study.setStatus(DcmConstants.STUDY_STATUS_UPLOADED);
        }
        if (existing == null)
        {
            study.setCreateBy(userName);
            studyMapper.insertDcmStudy(study);
        }
        else
        {
            studyMapper.updateDcmStudy(study);
        }
        return study;
    }

    private void syncSeriesAndInstances(Long studyId, JSONArray seriesIds, String userName)
    {
        for (Object value : seriesIds)
        {
            String orthancSeriesId = String.valueOf(value);
            JSONObject orthancSeries = orthancService.getSeries(orthancSeriesId);
            JSONArray instanceIds = orthancSeries.getJSONArray("Instances");
            if (instanceIds == null || instanceIds.isEmpty())
            {
                continue;
            }
            JSONObject seriesTags = orthancService.getInstanceSimplifiedTags(String.valueOf(instanceIds.get(0)));
            requireTag(seriesTags, "StudyInstanceUID");
            String seriesUid = requireTag(seriesTags, "SeriesInstanceUID");
            DcmSeries series = upsertSeries(studyId, orthancSeriesId, seriesUid, seriesTags, instanceIds.size(), userName);
            for (Object instanceId : instanceIds)
            {
                String orthancInstanceId = String.valueOf(instanceId);
                JSONObject tags = orthancService.getInstanceSimplifiedTags(orthancInstanceId);
                requireTag(tags, "StudyInstanceUID");
                requireTag(tags, "SeriesInstanceUID");
                String sopUid = requireTag(tags, "SOPInstanceUID");
                upsertInstance(studyId, series.getId(), orthancInstanceId, sopUid, tags, userName);
            }
        }
    }

    private DcmSeries upsertSeries(Long studyId, String orthancSeriesId, String seriesUid, JSONObject tags,
            int instanceCount, String userName)
    {
        DcmSeries existing = seriesMapper.selectDcmSeriesByUid(seriesUid);
        DcmSeries series = existing == null ? new DcmSeries() : existing;
        series.setStudyId(studyId);
        series.setOrthancSeriesId(orthancSeriesId);
        series.setSeriesInstanceUid(seriesUid);
        series.setSeriesNumber(tag(tags, "SeriesNumber"));
        series.setSeriesDescription(tag(tags, "SeriesDescription"));
        series.setModality(tag(tags, "Modality"));
        series.setBodyPartExamined(tag(tags, "BodyPartExamined"));
        series.setInstanceCount(instanceCount);
        series.setDelFlag(DcmConstants.DEL_FLAG_NORMAL);
        series.setUpdateBy(userName);
        if (existing == null)
        {
            series.setCreateBy(userName);
            seriesMapper.insertDcmSeries(series);
        }
        else
        {
            seriesMapper.updateDcmSeries(series);
        }
        return series;
    }

    private void upsertInstance(Long studyId, Long seriesId, String orthancInstanceId, String sopUid,
            JSONObject tags, String userName)
    {
        DcmInstance existing = instanceMapper.selectDcmInstanceByUid(sopUid);
        DcmInstance instance = existing == null ? new DcmInstance() : existing;
        instance.setStudyId(studyId);
        instance.setSeriesId(seriesId);
        instance.setOrthancInstanceId(orthancInstanceId);
        instance.setSopInstanceUid(sopUid);
        instance.setInstanceNumber(tag(tags, "InstanceNumber"));
        instance.setSopClassUid(tag(tags, "SOPClassUID"));
        instance.setImageType(tag(tags, "ImageType"));
        instance.setRows(integerTag(tags, "Rows"));
        instance.setColumns(integerTag(tags, "Columns"));
        instance.setPixelSpacing(tag(tags, "PixelSpacing"));
        instance.setSliceLocation(tag(tags, "SliceLocation"));
        instance.setDelFlag(DcmConstants.DEL_FLAG_NORMAL);
        instance.setUpdateBy(userName);
        if (existing == null)
        {
            instance.setCreateBy(userName);
            instanceMapper.insertDcmInstance(instance);
        }
        else
        {
            instanceMapper.updateDcmInstance(instance);
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

    private Integer integerTag(JSONObject tags, String name)
    {
        String value = tag(tags, name);
        if (StringUtils.isEmpty(value))
        {
            return null;
        }
        try
        {
            return Integer.valueOf(value);
        }
        catch (NumberFormatException ex)
        {
            return null;
        }
    }
}
