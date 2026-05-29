package com.ruoyi.dcm.domain;

/**
 * Upload and index synchronization response.
 */
public class DcmUploadResult
{
    private Long studyId;
    private String orthancStudyId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String patientName;
    private String studyDescription;
    private String ohifViewerUrl;

    public Long getStudyId() { return studyId; }
    public void setStudyId(Long studyId) { this.studyId = studyId; }
    public String getOrthancStudyId() { return orthancStudyId; }
    public void setOrthancStudyId(String orthancStudyId) { this.orthancStudyId = orthancStudyId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getStudyDescription() { return studyDescription; }
    public void setStudyDescription(String studyDescription) { this.studyDescription = studyDescription; }
    public String getOhifViewerUrl() { return ohifViewerUrl; }
    public void setOhifViewerUrl(String ohifViewerUrl) { this.ohifViewerUrl = ohifViewerUrl; }
}
