package com.ruoyi.ndt.position.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtInspectionPosition extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long workpieceId;
    private String workpieceName;
    private Long taskId;
    private String positionName;
    private String positionCode;
    private Integer sortNo;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getWorkpieceId() { return workpieceId; }
    public void setWorkpieceId(Long workpieceId) { this.workpieceId = workpieceId; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }
    public String getPositionCode() { return positionCode; }
    public void setPositionCode(String positionCode) { this.positionCode = positionCode; }
    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
