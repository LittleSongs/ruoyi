package com.ruoyi.ndt.dicom.domain;

import java.util.List;

public class NdtDicomObjectUploadResult
{
    private Long objectId;
    private Long positionId;
    private Long validationRecordId;
    private String fileName;
    private String studyUid;
    private String seriesUid;
    private String sopInstanceUid;
    private String sopClassUid;
    private String orthancInstanceId;
    private String fileSha256;
    private String officialStatus;
    private String customStatus;
    private String finalStatus;
    private List<String> errors;

    public Long getObjectId() { return objectId; }
    public void setObjectId(Long objectId) { this.objectId = objectId; }
    public Long getPositionId() { return positionId; }
    public void setPositionId(Long positionId) { this.positionId = positionId; }
    public Long getValidationRecordId() { return validationRecordId; }
    public void setValidationRecordId(Long validationRecordId) { this.validationRecordId = validationRecordId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getStudyUid() { return studyUid; }
    public void setStudyUid(String studyUid) { this.studyUid = studyUid; }
    public String getSeriesUid() { return seriesUid; }
    public void setSeriesUid(String seriesUid) { this.seriesUid = seriesUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
    public String getFileSha256() { return fileSha256; }
    public void setFileSha256(String fileSha256) { this.fileSha256 = fileSha256; }
    public String getOfficialStatus() { return officialStatus; }
    public void setOfficialStatus(String officialStatus) { this.officialStatus = officialStatus; }
    public String getCustomStatus() { return customStatus; }
    public void setCustomStatus(String customStatus) { this.customStatus = customStatus; }
    public String getFinalStatus() { return finalStatus; }
    public void setFinalStatus(String finalStatus) { this.finalStatus = finalStatus; }
    public List<String> getErrors() { return errors; }
    public void setErrors(List<String> errors) { this.errors = errors; }
}
