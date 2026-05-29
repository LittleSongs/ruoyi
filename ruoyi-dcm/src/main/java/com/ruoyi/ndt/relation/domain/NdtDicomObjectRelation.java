package com.ruoyi.ndt.relation.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Relation between original DICOM objects and derived objects/evaluations.
 */
public class NdtDicomObjectRelation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long taskId;
    private String sourceSopInstanceUid;
    private String relatedSopInstanceUid;
    private String relatedType;
    private String relatedSeriesInstanceUid;
    private String orthancInstanceId;
    private Long evaluationId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String sourceSopInstanceUid) { this.sourceSopInstanceUid = sourceSopInstanceUid; }
    public String getRelatedSopInstanceUid() { return relatedSopInstanceUid; }
    public void setRelatedSopInstanceUid(String relatedSopInstanceUid) { this.relatedSopInstanceUid = relatedSopInstanceUid; }
    public String getRelatedType() { return relatedType; }
    public void setRelatedType(String relatedType) { this.relatedType = relatedType; }
    public String getRelatedSeriesInstanceUid() { return relatedSeriesInstanceUid; }
    public void setRelatedSeriesInstanceUid(String relatedSeriesInstanceUid) { this.relatedSeriesInstanceUid = relatedSeriesInstanceUid; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
    public Long getEvaluationId() { return evaluationId; }
    public void setEvaluationId(Long evaluationId) { this.evaluationId = evaluationId; }
    @Override
    public Date getCreateTime() { return createTime; }
    @Override
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
