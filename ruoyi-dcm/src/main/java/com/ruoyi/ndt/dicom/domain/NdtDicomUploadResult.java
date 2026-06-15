package com.ruoyi.ndt.dicom.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * DICOM upload result.
 */
public class NdtDicomUploadResult
{
    private Long taskId;
    private Long dicomInstanceId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String orthancStudyId;
    private String orthancSeriesId;
    private String orthancInstanceId;
    private String fileSha256;
    private String ohifViewerUrl;
    private Long validationRecordId;
    private String fileName;
    private String sopClassUid;
    private String officialStatus;
    private String customStatus;
    private String finalStatus;
    private List<String> errors = new ArrayList<>();

    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public Long getDicomInstanceId() { return dicomInstanceId; }
    public void setDicomInstanceId(Long dicomInstanceId) { this.dicomInstanceId = dicomInstanceId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getOrthancStudyId() { return orthancStudyId; }
    public void setOrthancStudyId(String orthancStudyId) { this.orthancStudyId = orthancStudyId; }
    public String getOrthancSeriesId() { return orthancSeriesId; }
    public void setOrthancSeriesId(String orthancSeriesId) { this.orthancSeriesId = orthancSeriesId; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
    public String getFileSha256() { return fileSha256; }
    public void setFileSha256(String fileSha256) { this.fileSha256 = fileSha256; }
    public String getOhifViewerUrl() { return ohifViewerUrl; }
    public void setOhifViewerUrl(String ohifViewerUrl) { this.ohifViewerUrl = ohifViewerUrl; }
    public Long getValidationRecordId() { return validationRecordId; }
    public void setValidationRecordId(Long validationRecordId) { this.validationRecordId = validationRecordId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getOfficialStatus() { return officialStatus; }
    public void setOfficialStatus(String officialStatus) { this.officialStatus = officialStatus; }
    public String getCustomStatus() { return customStatus; }
    public void setCustomStatus(String customStatus) { this.customStatus = customStatus; }
    public String getFinalStatus() { return finalStatus; }
    public void setFinalStatus(String finalStatus) { this.finalStatus = finalStatus; }
    public List<String> getErrors() { return errors; }
    public void setErrors(List<String> errors) { this.errors = errors; }
}
