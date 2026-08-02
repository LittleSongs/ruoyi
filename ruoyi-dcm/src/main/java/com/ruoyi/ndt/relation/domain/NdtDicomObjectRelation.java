package com.ruoyi.ndt.relation.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtDicomObjectRelation extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long sourceObjectId;
    private Long targetObjectId;
    private String relationType;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getSourceObjectId() { return sourceObjectId; }
    public void setSourceObjectId(Long sourceObjectId) { this.sourceObjectId = sourceObjectId; }
    public Long getTargetObjectId() { return targetObjectId; }
    public void setTargetObjectId(Long targetObjectId) { this.targetObjectId = targetObjectId; }
    public String getRelationType() { return relationType; }
    public void setRelationType(String relationType) { this.relationType = relationType; }
}
