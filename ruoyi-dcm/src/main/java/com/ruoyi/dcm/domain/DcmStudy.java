package com.ruoyi.dcm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * DICOM study index entity.
 */
public class DcmStudy extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String orthancStudyId;
    private String studyInstanceUid;
    private String studyDescription;
    private String studyDate;
    private String accessionNumber;
    private String patientId;
    private String patientName;
    private String patientSex;
    private String patientBirthDate;
    private String modality;
    private Integer seriesCount;
    private Integer instanceCount;
    private Long uploadUserId;
    private String uploadUserName;
    private String status;
    private String delFlag;
    private String ohifViewerUrl;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOrthancStudyId() { return orthancStudyId; }
    public void setOrthancStudyId(String orthancStudyId) { this.orthancStudyId = orthancStudyId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getStudyDescription() { return studyDescription; }
    public void setStudyDescription(String studyDescription) { this.studyDescription = studyDescription; }
    public String getStudyDate() { return studyDate; }
    public void setStudyDate(String studyDate) { this.studyDate = studyDate; }
    public String getAccessionNumber() { return accessionNumber; }
    public void setAccessionNumber(String accessionNumber) { this.accessionNumber = accessionNumber; }
    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getPatientSex() { return patientSex; }
    public void setPatientSex(String patientSex) { this.patientSex = patientSex; }
    public String getPatientBirthDate() { return patientBirthDate; }
    public void setPatientBirthDate(String patientBirthDate) { this.patientBirthDate = patientBirthDate; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public Integer getSeriesCount() { return seriesCount; }
    public void setSeriesCount(Integer seriesCount) { this.seriesCount = seriesCount; }
    public Integer getInstanceCount() { return instanceCount; }
    public void setInstanceCount(Integer instanceCount) { this.instanceCount = instanceCount; }
    public Long getUploadUserId() { return uploadUserId; }
    public void setUploadUserId(Long uploadUserId) { this.uploadUserId = uploadUserId; }
    public String getUploadUserName() { return uploadUserName; }
    public void setUploadUserName(String uploadUserName) { this.uploadUserName = uploadUserName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getOhifViewerUrl() { return ohifViewerUrl; }
    public void setOhifViewerUrl(String ohifViewerUrl) { this.ohifViewerUrl = ohifViewerUrl; }
}
