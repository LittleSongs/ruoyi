package com.ruoyi.ndt.evaluation.domain;

import java.util.ArrayList;
import java.util.List;

public class NdtEvaluationHistoryPart
{
    private Long id;
    private String partNo;
    private String partName;
    private String sourceSopInstanceUid;
    private List<NdtEvaluationHistoryItem> evaluations = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long value) { this.id = value; }
    public String getPartNo() { return partNo; }
    public void setPartNo(String value) { this.partNo = value; }
    public String getPartName() { return partName; }
    public void setPartName(String value) { this.partName = value; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String value) { this.sourceSopInstanceUid = value; }
    public List<NdtEvaluationHistoryItem> getEvaluations() { return evaluations; }
    public void setEvaluations(List<NdtEvaluationHistoryItem> value) { this.evaluations = value; }
}
