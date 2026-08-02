package com.ruoyi.ndt.study.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtInspectionStudy extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long workpieceId;
    private String workpieceName;
    private Long taskId;
    private String studyInstanceUid;
    private String inspectionMethodCode;
    private String studyNo;
    private String studyDescription;
    private String studyDate;
    private String studyTime;
    private String orthancStudyId;
    private String status;
    private Integer seriesCount;
    private Integer objectCount;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getWorkpieceId() { return workpieceId; }
    public void setWorkpieceId(Long workpieceId) { this.workpieceId = workpieceId; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getInspectionMethodCode() { return inspectionMethodCode; }
    public void setInspectionMethodCode(String inspectionMethodCode) { this.inspectionMethodCode = inspectionMethodCode; }
    public String getStudyNo() { return studyNo; }
    public void setStudyNo(String studyNo) { this.studyNo = studyNo; }
    public String getStudyDescription() { return studyDescription; }
    public void setStudyDescription(String studyDescription) { this.studyDescription = studyDescription; }
    public String getStudyDate() { return studyDate; }
    public void setStudyDate(String studyDate) { this.studyDate = studyDate; }
    public String getStudyTime() { return studyTime; }
    public void setStudyTime(String studyTime) { this.studyTime = studyTime; }
    public String getOrthancStudyId() { return orthancStudyId; }
    public void setOrthancStudyId(String orthancStudyId) { this.orthancStudyId = orthancStudyId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getSeriesCount() { return seriesCount; }
    public void setSeriesCount(Integer seriesCount) { this.seriesCount = seriesCount; }
    public Integer getObjectCount() { return objectCount; }
    public void setObjectCount(Integer objectCount) { this.objectCount = objectCount; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
