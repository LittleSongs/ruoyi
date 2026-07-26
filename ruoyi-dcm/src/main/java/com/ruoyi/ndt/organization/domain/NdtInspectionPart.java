package com.ruoyi.ndt.organization.domain;

public class NdtInspectionPart
{
    private Long id;
    private Long taskId;
    private String partNo;
    private String partName;
    private Long sourceDicomInstanceId;
    private String sourceSopInstanceUid;
    private Integer sortOrder;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long value) { this.taskId = value; }
    public String getPartNo() { return partNo; }
    public void setPartNo(String value) { this.partNo = value; }
    public String getPartName() { return partName; }
    public void setPartName(String value) { this.partName = value; }
    public Long getSourceDicomInstanceId() { return sourceDicomInstanceId; }
    public void setSourceDicomInstanceId(Long value) { this.sourceDicomInstanceId = value; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String value) { this.sourceSopInstanceUid = value; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer value) { this.sortOrder = value; }
}
