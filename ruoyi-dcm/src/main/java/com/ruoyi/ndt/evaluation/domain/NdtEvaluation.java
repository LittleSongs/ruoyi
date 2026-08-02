package com.ruoyi.ndt.evaluation.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

public class NdtEvaluation extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private String evaluationType;
    private Long defectId;
    private Long workpieceId;
    private Long taskId;
    private String defectNo;
    private String workpieceName;
    private String level;
    private String conclusion;
    private String description;
    private Long evaluatorId;
    private String evaluatorName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date evaluationTime;
    private String status;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEvaluationType() { return evaluationType; }
    public void setEvaluationType(String evaluationType) { this.evaluationType = evaluationType; }
    public Long getDefectId() { return defectId; }
    public void setDefectId(Long defectId) { this.defectId = defectId; }
    public Long getWorkpieceId() { return workpieceId; }
    public void setWorkpieceId(Long workpieceId) { this.workpieceId = workpieceId; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getDefectNo() { return defectNo; }
    public void setDefectNo(String defectNo) { this.defectNo = defectNo; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getConclusion() { return conclusion; }
    public void setConclusion(String conclusion) { this.conclusion = conclusion; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Long getEvaluatorId() { return evaluatorId; }
    public void setEvaluatorId(Long evaluatorId) { this.evaluatorId = evaluatorId; }
    public String getEvaluatorName() { return evaluatorName; }
    public void setEvaluatorName(String evaluatorName) { this.evaluatorName = evaluatorName; }
    public Date getEvaluationTime() { return evaluationTime; }
    public void setEvaluationTime(Date evaluationTime) { this.evaluationTime = evaluationTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
