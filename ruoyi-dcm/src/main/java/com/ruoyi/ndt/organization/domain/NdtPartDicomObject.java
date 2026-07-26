package com.ruoyi.ndt.organization.domain;

public class NdtPartDicomObject
{
    private Long id;
    private Long taskId;
    private Long partId;
    private Long dicomInstanceId;
    private String objectRole;
    private Integer sortOrder;
    private String primaryFlag;

    public Long getId() { return id; }
    public void setId(Long value) { this.id = value; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long value) { this.taskId = value; }
    public Long getPartId() { return partId; }
    public void setPartId(Long value) { this.partId = value; }
    public Long getDicomInstanceId() { return dicomInstanceId; }
    public void setDicomInstanceId(Long value) { this.dicomInstanceId = value; }
    public String getObjectRole() { return objectRole; }
    public void setObjectRole(String value) { this.objectRole = value; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer value) { this.sortOrder = value; }
    public String getPrimaryFlag() { return primaryFlag; }
    public void setPrimaryFlag(String value) { this.primaryFlag = value; }
}
