package com.ruoyi.ndt.dicom.domain;

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
}
