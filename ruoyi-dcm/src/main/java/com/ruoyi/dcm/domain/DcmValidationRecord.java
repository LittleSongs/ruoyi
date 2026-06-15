package com.ruoyi.dcm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * DICOM validation execution record.
 */
public class DcmValidationRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;
    private Long batchId;
    private String fileName;
    private Long fileSize;
    private String tempPath;
    private String sopClassUid;
    private String mediaStorageSopClassUid;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;
    private String officialStatus;
    private String customStatus;
    private String finalStatus;
    private Integer errorCount;
    private Integer warningCount;
    private String officialResultJson;
    private String customResultJson;
    private String orthancInstanceId;

    public Long getRecordId() { return recordId; }
    public void setRecordId(Long recordId) { this.recordId = recordId; }
    public Long getBatchId() { return batchId; }
    public void setBatchId(Long batchId) { this.batchId = batchId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
    public String getTempPath() { return tempPath; }
    public void setTempPath(String tempPath) { this.tempPath = tempPath; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getMediaStorageSopClassUid() { return mediaStorageSopClassUid; }
    public void setMediaStorageSopClassUid(String mediaStorageSopClassUid) { this.mediaStorageSopClassUid = mediaStorageSopClassUid; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public String getOfficialStatus() { return officialStatus; }
    public void setOfficialStatus(String officialStatus) { this.officialStatus = officialStatus; }
    public String getCustomStatus() { return customStatus; }
    public void setCustomStatus(String customStatus) { this.customStatus = customStatus; }
    public String getFinalStatus() { return finalStatus; }
    public void setFinalStatus(String finalStatus) { this.finalStatus = finalStatus; }
    public Integer getErrorCount() { return errorCount; }
    public void setErrorCount(Integer errorCount) { this.errorCount = errorCount; }
    public Integer getWarningCount() { return warningCount; }
    public void setWarningCount(Integer warningCount) { this.warningCount = warningCount; }
    public String getOfficialResultJson() { return officialResultJson; }
    public void setOfficialResultJson(String officialResultJson) { this.officialResultJson = officialResultJson; }
    public String getCustomResultJson() { return customResultJson; }
    public void setCustomResultJson(String customResultJson) { this.customResultJson = customResultJson; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
}
