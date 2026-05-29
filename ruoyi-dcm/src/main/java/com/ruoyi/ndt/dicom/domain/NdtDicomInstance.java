package com.ruoyi.ndt.dicom.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * NDT DICOM instance index.
 */
public class NdtDicomInstance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long taskId;
    private String taskNo;
    private String taskName;
    private String workpieceName;
    private Long customerDeptId;
    private String customerDeptName;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String orthancStudyId;
    private String orthancSeriesId;
    private String orthancInstanceId;
    private String modality;
    private String seriesNumber;
    private String instanceNumber;
    private String seriesDescription;
    private String sopClassUid;
    private String isOriginal;
    private String fileName;
    private Long fileSize;
    private Long uploadUserId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date uploadTime;
    private String integrityStatus;
    private String delFlag;
    private String ohifViewerUrl;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getTaskNo() { return taskNo; }
    public void setTaskNo(String taskNo) { this.taskNo = taskNo; }
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public Long getCustomerDeptId() { return customerDeptId; }
    public void setCustomerDeptId(Long customerDeptId) { this.customerDeptId = customerDeptId; }
    public String getCustomerDeptName() { return customerDeptName; }
    public void setCustomerDeptName(String customerDeptName) { this.customerDeptName = customerDeptName; }
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
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public String getSeriesNumber() { return seriesNumber; }
    public void setSeriesNumber(String seriesNumber) { this.seriesNumber = seriesNumber; }
    public String getInstanceNumber() { return instanceNumber; }
    public void setInstanceNumber(String instanceNumber) { this.instanceNumber = instanceNumber; }
    public String getSeriesDescription() { return seriesDescription; }
    public void setSeriesDescription(String seriesDescription) { this.seriesDescription = seriesDescription; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getIsOriginal() { return isOriginal; }
    public void setIsOriginal(String isOriginal) { this.isOriginal = isOriginal; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
    public Long getUploadUserId() { return uploadUserId; }
    public void setUploadUserId(Long uploadUserId) { this.uploadUserId = uploadUserId; }
    public Date getUploadTime() { return uploadTime; }
    public void setUploadTime(Date uploadTime) { this.uploadTime = uploadTime; }
    public String getIntegrityStatus() { return integrityStatus; }
    public void setIntegrityStatus(String integrityStatus) { this.integrityStatus = integrityStatus; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getOhifViewerUrl() { return ohifViewerUrl; }
    public void setOhifViewerUrl(String ohifViewerUrl) { this.ohifViewerUrl = ohifViewerUrl; }
}
