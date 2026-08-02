package com.ruoyi.ndt.workpiece.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtWorkpiece extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long taskId;
    private String taskName;
    private String workpieceName;
    private Integer sortNo;
    private String status;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
