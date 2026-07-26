package com.ruoyi.ndt.evaluation.domain;

import java.util.Date;

public class NdtEvaluationHistoryRow
{
    private Long partId;
    private String partNo;
    private String partName;
    private String sourceSopInstanceUid;
    private Long evaluationId;
    private Long evaluatorUserId;
    private String evaluatorUserName;
    private Date evaluateTime;
    private String defectType;
    private String defectLevel;
    private String conclusion;
    private String status;

    public Long getPartId() { return partId; }
    public void setPartId(Long value) { this.partId = value; }
    public String getPartNo() { return partNo; }
    public void setPartNo(String value) { this.partNo = value; }
    public String getPartName() { return partName; }
    public void setPartName(String value) { this.partName = value; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String value) { this.sourceSopInstanceUid = value; }
    public Long getEvaluationId() { return evaluationId; }
    public void setEvaluationId(Long value) { this.evaluationId = value; }
    public Long getEvaluatorUserId() { return evaluatorUserId; }
    public void setEvaluatorUserId(Long value) { this.evaluatorUserId = value; }
    public String getEvaluatorUserName() { return evaluatorUserName; }
    public void setEvaluatorUserName(String value) { this.evaluatorUserName = value; }
    public Date getEvaluateTime() { return evaluateTime; }
    public void setEvaluateTime(Date value) { this.evaluateTime = value; }
    public String getDefectType() { return defectType; }
    public void setDefectType(String value) { this.defectType = value; }
    public String getDefectLevel() { return defectLevel; }
    public void setDefectLevel(String value) { this.defectLevel = value; }
    public String getConclusion() { return conclusion; }
    public void setConclusion(String value) { this.conclusion = value; }
    public String getStatus() { return status; }
    public void setStatus(String value) { this.status = value; }
}
