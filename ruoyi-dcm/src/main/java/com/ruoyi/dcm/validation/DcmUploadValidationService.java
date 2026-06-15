package com.ruoyi.dcm.validation;

import java.nio.file.Path;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.dcm.domain.DcmValidationRecord;
import com.ruoyi.dcm.mapper.DcmValidationRecordMapper;

@Service
public class DcmUploadValidationService
{
    @Autowired
    private DcmDicomMetadataReader metadataReader;

    @Autowired
    private DcmOfficialValidator officialValidator;

    @Autowired
    private DcmCustomRuleValidator customRuleValidator;

    @Autowired
    private DcmValidationRecordMapper recordMapper;

    public DcmUploadValidationResult validate(Path tempPath, MultipartFile file, String username)
    {
        DcmDicomMetadata metadata = metadataReader.read(tempPath);
        DcmOfficialValidationResult officialResult = officialValidator.validate(tempPath);
        DcmCustomValidationResult customResult = customRuleValidator.validate(metadata);
        String finalStatus = "PASS".equals(officialResult.getStatus()) && "PASS".equals(customResult.getStatus())
                ? "PASS" : "FAIL";

        DcmValidationRecord record = new DcmValidationRecord();
        record.setFileName(file.getOriginalFilename());
        record.setFileSize(file.getSize());
        record.setTempPath(tempPath.toString());
        record.setSopClassUid(metadata.getSopClassUid());
        record.setMediaStorageSopClassUid(metadata.getMediaStorageSopClassUid());
        record.setStudyInstanceUid(metadata.getStudyInstanceUid());
        record.setSeriesInstanceUid(metadata.getSeriesInstanceUid());
        record.setSopInstanceUid(metadata.getSopInstanceUid());
        record.setModality(metadata.getModality());
        record.setOfficialStatus(officialResult.getStatus());
        record.setCustomStatus(customResult.getStatus());
        record.setFinalStatus(finalStatus);
        record.setErrorCount(customResult.getErrors().size() + ("PASS".equals(officialResult.getStatus()) ? 0 : 1));
        record.setWarningCount(customResult.getWarnings().size());
        record.setOfficialResultJson(JSON.toJSONString(officialResult));
        record.setCustomResultJson(JSON.toJSONString(customResult));
        record.setCreateBy(username);
        recordMapper.insertDcmValidationRecord(record);

        DcmUploadValidationResult result = new DcmUploadValidationResult();
        result.setRecordId(record.getRecordId());
        result.setFileName(file.getOriginalFilename());
        result.setSopClassUid(metadata.getSopClassUid());
        result.setStudyInstanceUid(metadata.getStudyInstanceUid());
        result.setSeriesInstanceUid(metadata.getSeriesInstanceUid());
        result.setSopInstanceUid(metadata.getSopInstanceUid());
        result.setOfficialStatus(officialResult.getStatus());
        result.setCustomStatus(customResult.getStatus());
        result.setFinalStatus(finalStatus);
        result.getErrors().addAll(customResult.getErrors().stream().map(DcmValidationFailure::getMessage).collect(Collectors.toList()));
        if (!"PASS".equals(officialResult.getStatus()))
        {
            result.getErrors().add("validate_iods 官方校验失败：" + officialResult.getStdout());
        }
        return result;
    }

    public void markOrthancUploaded(Long recordId, String orthancInstanceId)
    {
        if (recordId == null)
        {
            return;
        }
        DcmValidationRecord record = new DcmValidationRecord();
        record.setRecordId(recordId);
        record.setOrthancInstanceId(orthancInstanceId);
        recordMapper.updateDcmValidationRecordOrthancInstanceId(record);
    }
}
