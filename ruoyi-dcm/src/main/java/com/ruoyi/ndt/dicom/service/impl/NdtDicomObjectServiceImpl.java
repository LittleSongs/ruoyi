package com.ruoyi.ndt.dicom.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.validation.DcmUploadValidationResult;
import com.ruoyi.dcm.validation.DcmUploadValidationService;
import com.ruoyi.ndt.common.NdtBusinessRules;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.domain.NdtDicomObjectUploadResult;
import com.ruoyi.ndt.dicom.dto.NdtDicomDerivedObjectDto;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.dicom.service.INdtDicomObjectService;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;
import com.ruoyi.ndt.integrity.mapper.NdtDicomIntegrityRecordMapper;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.mapper.NdtInspectionPositionMapper;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.series.domain.NdtDicomSeries;
import com.ruoyi.ndt.series.mapper.NdtDicomSeriesMapper;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;
import com.ruoyi.ndt.study.service.NdtHierarchyRules;

@Service
public class NdtDicomObjectServiceImpl implements INdtDicomObjectService
{
    private final NdtDicomObjectMapper mapper;
    private final NdtInspectionPositionMapper positionMapper;
    private final NdtInspectionStudyMapper studyMapper;
    private final NdtDicomSeriesMapper seriesMapper;
    private final NdtDicomObjectRelationMapper relationMapper;
    private final NdtDicomIntegrityRecordMapper integrityMapper;
    private final INdtIntegrityService integrityService;
    private final OrthancService orthanc;
    private final DcmUploadValidationService validationService;
    private final NdtAccessService access;

    public NdtDicomObjectServiceImpl(NdtDicomObjectMapper mapper,
            NdtInspectionPositionMapper positionMapper, NdtInspectionStudyMapper studyMapper,
            NdtDicomSeriesMapper seriesMapper, NdtDicomObjectRelationMapper relationMapper,
            NdtDicomIntegrityRecordMapper integrityMapper, INdtIntegrityService integrityService,
            OrthancService orthanc, DcmUploadValidationService validationService, NdtAccessService access)
    {
        this.mapper = mapper; this.positionMapper = positionMapper; this.studyMapper = studyMapper;
        this.seriesMapper = seriesMapper; this.relationMapper = relationMapper;
        this.integrityMapper = integrityMapper; this.integrityService = integrityService;
        this.orthanc = orthanc; this.validationService = validationService; this.access = access;
    }

    public List<NdtDicomObject> selectList(NdtDicomObject query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }

    public NdtDicomObject selectById(Long id)
    {
        NdtDicomObject object = require(id); access.checkViewTask(object.getTaskId()); return object;
    }

    @Transactional(rollbackFor = Exception.class)
    public NdtDicomObjectUploadResult uploadOriginal(Long positionId, MultipartFile file,
            Long userId, String username)
    {
        NdtInspectionPosition position = requirePositionForUpdate(positionId);
        access.checkUploadTask(position.getTaskId());
        byte[] content = read(file);
        String sha256 = integrityService.calculateSha256(content);
        Path temp = temp(content);
        DcmUploadValidationResult validation;
        try { validation = validationService.validate(temp, file, username); }
        finally { deleteTemp(temp); }
        if (!"PASS".equals(validation.getFinalStatus()))
            return validationResult(positionId, sha256, validation);
        if (mapper.selectBySopInstanceUid(validation.getSopInstanceUid()) != null)
            throw new ServiceException("SOPInstanceUID已存在，不能重复上传");

        JSONObject response = orthanc.uploadInstance(content);
        String orthancId = required(response.getString("ID"), "Orthanc响应缺少Instance ID");
        try
        {
            JSONObject tags = orthanc.getInstanceSimplifiedTags(orthancId);
            NdtInspectionStudy study = resolveStudy(position, tags, response.getString("ParentStudy"), username);
            String incomingSeriesUid = required(tags.getString("SeriesInstanceUID"),
                    "DICOM缺少SeriesInstanceUID");
            NdtDicomObject existingOriginal = mapper.selectOriginalByStudyAndPosition(
                    study.getId(), position.getId());
            if (existingOriginal != null)
            {
                if (incomingSeriesUid.equals(existingOriginal.getSeriesUid()))
                    throw new ServiceException("一个Series只能包含一张原始图");
                throw new ServiceException("同一Study中的一个检测部位只能对应一个影像Series");
            }
            NdtDicomSeries series = resolveSeries(study, position, tags,
                    response.getString("ParentSeries"), username);
            if (mapper.selectOriginalBySeriesId(series.getId()) != null)
                throw new ServiceException("一个Series只能包含一张原始图");
            NdtDicomObject object = new NdtDicomObject();
            object.setSeriesId(series.getId());
            object.setObjectType(NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE);
            object.setObjectName(file.getOriginalFilename());
            object.setStorageType(NdtConstants.STORAGE_TYPE_ORTHANC);
            object.setOrthancInstanceId(orthancId);
            object.setMimeType("application/dicom");
            object.setStudyUid(required(tags.getString("StudyInstanceUID"), "DICOM缺少StudyInstanceUID"));
            object.setSeriesUid(required(tags.getString("SeriesInstanceUID"), "DICOM缺少SeriesInstanceUID"));
            object.setSopInstanceUid(required(tags.getString("SOPInstanceUID"), "DICOM缺少SOPInstanceUID"));
            object.setSopClassUid(tags.getString("SOPClassUID"));
            object.setMetadataJson(tags.toJSONString());
            object.setSha256(sha256);
            object.setCreateBy(username); object.setUpdateBy(username);
            mapper.insert(object);
            validationService.markOrthancUploaded(validation.getRecordId(), orthancId);
            insertIntegrity(object, userId);
            NdtDicomObjectUploadResult result = validationResult(positionId, sha256, validation);
            result.setObjectId(object.getId()); result.setOrthancInstanceId(orthancId);
            result.setStudyUid(object.getStudyUid()); result.setSeriesUid(object.getSeriesUid());
            result.setSopInstanceUid(object.getSopInstanceUid()); result.setSopClassUid(object.getSopClassUid());
            return result;
        }
        catch (RuntimeException ex)
        {
            safeDeleteOrthanc(orthancId);
            throw ex;
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public NdtDicomObject createDerived(NdtDicomDerivedObjectDto dto, String username)
    {
        NdtDicomObject source = require(dto.getSourceObjectId());
        access.checkUploadTask(source.getTaskId());
        NdtBusinessRules.requireOriginalSource(source.getObjectType());
        if (dto.getPositionId() != null && !source.getPositionId().equals(dto.getPositionId()))
            throw new ServiceException("非DICOM衍生对象必须归入来源对象所在Series和检测部位");
        if (dto.getPositionId() == null) dto.setPositionId(source.getPositionId());
        NdtInspectionPosition targetPosition = requirePosition(dto.getPositionId());
        if (!source.getTaskId().equals(targetPosition.getTaskId()))
            throw new ServiceException("衍生对象与来源对象必须属于同一个任务");
        NdtBusinessRules.requireImageDerivedType(dto.getObjectType());
        NdtBusinessRules.requireStorageType(dto.getStorageType());
        dto.setSeriesId(source.getSeriesId());
        dto.setCreateBy(username); dto.setUpdateBy(username);
        mapper.insert(dto);
        insertRelation(source.getId(), dto.getId(), defaultRelation(dto.getRelationType()), username);
        return mapper.selectById(dto.getId());
    }

    @Transactional(rollbackFor = Exception.class)
    public NdtDicomObject uploadDerivedImageDicom(Long sourceObjectId, String objectType,
            MultipartFile file, Long userId, String username)
    {
        NdtDicomObject source = require(sourceObjectId);
        access.checkUploadTask(source.getTaskId());
        NdtBusinessRules.requireOriginalSource(source.getObjectType());
        NdtBusinessRules.requireImageDerivedType(objectType);
        return uploadRelatedDicom(source, objectType, NdtConstants.RELATION_TYPE_DERIVED_FROM,
                file, userId, username, true);
    }

    @Transactional(rollbackFor = Exception.class)
    public NdtDicomObject uploadDerivedDicom(Long sourceObjectId, String objectType, String relationType,
            MultipartFile file, Long userId, String username)
    {
        NdtDicomObject source = require(sourceObjectId);
        access.checkUploadTask(source.getTaskId());
        NdtBusinessRules.requireOriginalSource(source.getObjectType());
        NdtBusinessRules.requireNonImageDerivedType(objectType);
        return uploadRelatedDicom(source, objectType, relationType, file, userId, username, false);
    }

    private NdtDicomObject uploadRelatedDicom(NdtDicomObject source, String objectType,
            String relationType, MultipartFile file, Long userId, String username, boolean sameSeries)
    {
        byte[] content = read(file);
        JSONObject response = orthanc.uploadInstance(content);
        String orthancId = required(response.getString("ID"),
                "Orthanc响应缺少Instance ID");
        try
        {
            JSONObject tags = orthanc.getInstanceSimplifiedTags(orthancId);
            String studyUid = required(tags.getString("StudyInstanceUID"), "DICOM缺少StudyInstanceUID");
            String seriesUid = required(tags.getString("SeriesInstanceUID"), "DICOM缺少SeriesInstanceUID");
            String sopUid = required(tags.getString("SOPInstanceUID"), "DICOM缺少SOPInstanceUID");
            if (mapper.selectBySopInstanceUid(sopUid) != null)
                throw new ServiceException("SOPInstanceUID已存在，不能重复上传");
            if (sameSeries)
                NdtBusinessRules.requireSameSeriesPlacement(source.getStudyUid(), source.getSeriesUid(),
                        studyUid, seriesUid);
            else
                NdtBusinessRules.requireSeparateSeriesPlacement(source.getStudyUid(), source.getSeriesUid(),
                        studyUid, seriesUid);
            NdtInspectionStudy study = requireSourceStudy(source, studyUid);
            NdtInspectionPosition position = requirePosition(source.getPositionId());
            NdtDicomSeries series = resolveSeries(study, position, tags,
                    response.getString("ParentSeries"), username);
            NdtDicomObject object = new NdtDicomObject();
            object.setSeriesId(series.getId());
            object.setObjectType(objectType);
            object.setObjectName(file.getOriginalFilename());
            object.setStorageType(NdtConstants.STORAGE_TYPE_ORTHANC);
            object.setOrthancInstanceId(orthancId);
            object.setMimeType("application/dicom");
            object.setStudyUid(studyUid);
            object.setSeriesUid(seriesUid);
            object.setSopInstanceUid(sopUid);
            object.setSopClassUid(tags.getString("SOPClassUID"));
            object.setMetadataJson(tags.toJSONString());
            object.setSha256(integrityService.calculateSha256(content));
            object.setCreateBy(username); object.setUpdateBy(username);
            mapper.insert(object);
            insertRelation(source.getId(), object.getId(), defaultRelation(relationType), username);
            insertIntegrity(object, userId);
            return mapper.selectById(object.getId());
        }
        catch (RuntimeException ex)
        {
            safeDeleteOrthanc(orthancId); throw ex;
        }
    }

    public byte[] download(Long id)
    {
        NdtDicomObject object = selectById(id);
        if (!NdtConstants.STORAGE_TYPE_ORTHANC.equals(object.getStorageType())
                || StringUtils.isEmpty(object.getOrthancInstanceId()))
            throw new ServiceException("该对象不存储在Orthanc中");
        return orthanc.downloadInstanceFile(object.getOrthancInstanceId());
    }

    public JSONObject tags(Long id)
    {
        NdtDicomObject object = selectById(id);
        if (StringUtils.isEmpty(object.getOrthancInstanceId())) throw new ServiceException("该对象没有Orthanc实例");
        return orthanc.getInstanceTags(object.getOrthancInstanceId());
    }

    public List<NdtDicomObjectRelation> relations(Long id)
    {
        selectById(id); return relationMapper.selectByObjectId(id);
    }

    public int deleteByIds(Long[] ids)
    {
        for (Long id : ids) access.checkManageTask(require(id).getTaskId());
        return mapper.softDeleteByIds(ids);
    }

    private NdtDicomObject require(Long id)
    {
        NdtDicomObject object = mapper.selectById(id);
        if (object == null) throw new ServiceException("DICOM对象不存在"); return object;
    }
    private NdtInspectionPosition requirePosition(Long id)
    {
        NdtInspectionPosition value = positionMapper.selectById(id);
        if (value == null) throw new ServiceException("检测部位不存在"); return value;
    }

    private NdtInspectionPosition requirePositionForUpdate(Long id)
    {
        NdtInspectionPosition value = positionMapper.selectByIdForUpdate(id);
        if (value == null) throw new ServiceException("检测部位不存在");
        return value;
    }
    private NdtInspectionStudy resolveStudy(NdtInspectionPosition position, JSONObject tags,
            String orthancStudyId, String username)
    {
        String uid = required(tags.getString("StudyInstanceUID"), "DICOM缺少StudyInstanceUID");
        NdtInspectionStudy existing = studyMapper.selectByStudyInstanceUid(uid);
        if (existing != null)
        {
            NdtHierarchyRules.requireStudyOwnership(existing.getWorkpieceId(), position.getWorkpieceId());
            return existing;
        }
        NdtInspectionStudy study = new NdtInspectionStudy();
        study.setWorkpieceId(position.getWorkpieceId());
        study.setStudyInstanceUid(uid);
        study.setInspectionMethodCode(tags.getString("Modality"));
        study.setStudyNo(tags.getString("StudyID"));
        study.setStudyDescription(tags.getString("StudyDescription"));
        study.setStudyDate(tags.getString("StudyDate"));
        study.setStudyTime(tags.getString("StudyTime"));
        study.setOrthancStudyId(orthancStudyId);
        study.setStatus("ACTIVE");
        study.setCreateBy(username); study.setUpdateBy(username);
        studyMapper.insert(study);
        return study;
    }
    private NdtDicomSeries resolveSeries(NdtInspectionStudy study, NdtInspectionPosition position,
            JSONObject tags, String orthancSeriesId, String username)
    {
        String uid = required(tags.getString("SeriesInstanceUID"), "DICOM缺少SeriesInstanceUID");
        NdtDicomSeries existing = seriesMapper.selectBySeriesInstanceUid(uid);
        if (existing != null)
        {
            NdtHierarchyRules.requireSeriesOwnership(existing.getStudyId(), existing.getPositionId(),
                    study.getId(), position.getId());
            return existing;
        }
        NdtDicomSeries series = new NdtDicomSeries();
        series.setStudyId(study.getId());
        series.setWorkpieceId(position.getWorkpieceId());
        series.setPositionId(position.getId());
        series.setSeriesInstanceUid(uid);
        series.setModality(tags.getString("Modality"));
        series.setSeriesNumber(tags.getString("SeriesNumber"));
        series.setSeriesDescription(tags.getString("SeriesDescription"));
        series.setOrthancSeriesId(orthancSeriesId);
        series.setCreateBy(username); series.setUpdateBy(username);
        seriesMapper.insert(series);
        return series;
    }
    private NdtInspectionStudy requireSourceStudy(NdtDicomObject source, String studyUid)
    {
        NdtInspectionStudy study = studyMapper.selectByStudyInstanceUid(studyUid);
        if (study == null || !source.getStudyId().equals(study.getId()))
            throw new ServiceException("衍生DICOM必须与来源对象属于同一个Study");
        return study;
    }
    private byte[] read(MultipartFile file)
    {
        if (file == null || file.isEmpty()) throw new ServiceException("上传文件不能为空");
        try { return file.getBytes(); } catch (IOException ex) { throw new ServiceException("读取上传文件失败"); }
    }
    private Path temp(byte[] content)
    {
        try { Path path = Files.createTempFile("ruoyi-ndt-", ".dcm"); Files.write(path, content); return path; }
        catch (IOException ex) { throw new ServiceException("创建DICOM临时文件失败"); }
    }
    private void deleteTemp(Path path) { try { Files.deleteIfExists(path); } catch (IOException ignored) { } }
    private String required(String value, String message)
    {
        if (StringUtils.isEmpty(value)) throw new ServiceException(message); return value;
    }
    private String defaultRelation(String value)
    {
        return StringUtils.isEmpty(value) ? NdtConstants.RELATION_TYPE_DERIVED_FROM : value;
    }
    private void insertRelation(Long sourceId, Long targetId, String type, String username)
    {
        if (!List.of(NdtConstants.RELATION_TYPE_DERIVED_FROM, NdtConstants.RELATION_TYPE_REFERENCES,
                NdtConstants.RELATION_TYPE_GENERATED_FROM).contains(type))
            throw new ServiceException("对象关系类型不合法");
        NdtDicomObjectRelation relation = new NdtDicomObjectRelation();
        relation.setSourceObjectId(sourceId); relation.setTargetObjectId(targetId);
        relation.setRelationType(type); relation.setCreateBy(username); relationMapper.insert(relation);
    }
    private void insertIntegrity(NdtDicomObject object, Long userId)
    {
        NdtDicomIntegrityRecord record = new NdtDicomIntegrityRecord();
        record.setStudyInstanceUid(object.getStudyUid());
        record.setSeriesInstanceUid(object.getSeriesUid());
        record.setSopInstanceUid(object.getSopInstanceUid());
        record.setOrthancInstanceId(object.getOrthancInstanceId());
        record.setFileSha256(object.getSha256());
        record.setImportUserId(userId); record.setImportTime(new Date());
        record.setVerifyStatus(NdtConstants.INTEGRITY_STATUS_UNKNOWN);
        integrityMapper.insertNdtDicomIntegrityRecord(record);
    }
    private NdtDicomObjectUploadResult validationResult(Long positionId, String sha,
            DcmUploadValidationResult validation)
    {
        NdtDicomObjectUploadResult result = new NdtDicomObjectUploadResult();
        result.setPositionId(positionId); result.setFileSha256(sha);
        result.setValidationRecordId(validation.getRecordId()); result.setFileName(validation.getFileName());
        result.setSopClassUid(validation.getSopClassUid()); result.setStudyUid(validation.getStudyInstanceUid());
        result.setSeriesUid(validation.getSeriesInstanceUid()); result.setSopInstanceUid(validation.getSopInstanceUid());
        result.setOfficialStatus(validation.getOfficialStatus()); result.setCustomStatus(validation.getCustomStatus());
        result.setFinalStatus(validation.getFinalStatus()); result.setErrors(validation.getErrors());
        return result;
    }
    private void safeDeleteOrthanc(String id) { try { orthanc.deleteInstance(id); } catch (RuntimeException ignored) { } }
}
