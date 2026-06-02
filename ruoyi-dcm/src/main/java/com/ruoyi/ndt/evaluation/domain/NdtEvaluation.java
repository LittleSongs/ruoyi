package com.ruoyi.ndt.evaluation.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * NDT evaluation result.
 */
public class NdtEvaluation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long taskId;
    private String taskNo;
    private String taskName;
    @JsonProperty("studyInstanceUID")
    private String studyInstanceUid;
    @JsonProperty("seriesInstanceUID")
    private String seriesInstanceUid;
    @JsonProperty("sopInstanceUID")
    private String sopInstanceUid;
    private Long evaluatorUserId;
    private String evaluatorUserName;
    private String defectType;
    private String defectLevel;
    private String conclusion;
    private String annotationJson;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date evaluateTime;
    private String status;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getTaskNo() { return taskNo; }
    public void setTaskNo(String taskNo) { this.taskNo = taskNo; }
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public Long getEvaluatorUserId() { return evaluatorUserId; }
    public void setEvaluatorUserId(Long evaluatorUserId) { this.evaluatorUserId = evaluatorUserId; }
    public String getEvaluatorUserName() { return evaluatorUserName; }
    public void setEvaluatorUserName(String evaluatorUserName) { this.evaluatorUserName = evaluatorUserName; }
    public String getDefectType() { return defectType; }
    public void setDefectType(String defectType) { this.defectType = defectType; }
    public String getDefectLevel() { return defectLevel; }
    public void setDefectLevel(String defectLevel) { this.defectLevel = defectLevel; }
    public String getConclusion() { return conclusion; }
    public void setConclusion(String conclusion) { this.conclusion = conclusion; }
    public String getAnnotationJson() { return annotationJson; }
    public void setAnnotationJson(String annotationJson) { this.annotationJson = annotationJson; }
    public Date getEvaluateTime() { return evaluateTime; }
    public void setEvaluateTime(Date evaluateTime) { this.evaluateTime = evaluateTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
