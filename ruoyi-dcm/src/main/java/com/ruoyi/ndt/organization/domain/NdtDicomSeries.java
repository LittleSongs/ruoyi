package com.ruoyi.ndt.organization.domain;

public class NdtDicomSeries
{
    private Long id;
    private Long taskId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String orthancSeriesId;
    private String modality;
    private String seriesNumber;
    private String seriesDescription;
    private String seriesRole;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String value) { this.studyInstanceUid = value; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String value) { this.seriesInstanceUid = value; }
    public String getOrthancSeriesId() { return orthancSeriesId; }
    public void setOrthancSeriesId(String value) { this.orthancSeriesId = value; }
    public String getModality() { return modality; }
    public void setModality(String value) { this.modality = value; }
    public String getSeriesNumber() { return seriesNumber; }
    public void setSeriesNumber(String value) { this.seriesNumber = value; }
    public String getSeriesDescription() { return seriesDescription; }
    public void setSeriesDescription(String value) { this.seriesDescription = value; }
    public String getSeriesRole() { return seriesRole; }
    public void setSeriesRole(String value) { this.seriesRole = value; }
}
