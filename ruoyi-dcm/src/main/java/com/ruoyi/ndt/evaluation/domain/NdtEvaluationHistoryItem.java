package com.ruoyi.ndt.evaluation.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

public class NdtEvaluationHistoryItem
{
    private Long id;
    private Long evaluatorUserId;
    private String evaluatorUserName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date evaluateTime;
    private String defectType;
    private String defectLevel;
    private String conclusion;
    private String status;

    public Long getId() { return id; }
    public void setId(Long value) { this.id = value; }
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
