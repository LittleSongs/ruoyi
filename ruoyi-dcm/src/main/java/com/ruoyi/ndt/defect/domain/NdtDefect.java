package com.ruoyi.ndt.defect.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtDefect extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long originalObjectId;
    private Long taskId;
    private String defectNo;
    private String defectType;
    private String roiType;
    private String roiDataJson;
    private String description;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getOriginalObjectId() { return originalObjectId; }
    public void setOriginalObjectId(Long originalObjectId) { this.originalObjectId = originalObjectId; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getDefectNo() { return defectNo; }
    public void setDefectNo(String defectNo) { this.defectNo = defectNo; }
    public String getDefectType() { return defectType; }
    public void setDefectType(String defectType) { this.defectType = defectType; }
    public String getRoiType() { return roiType; }
    public void setRoiType(String roiType) { this.roiType = roiType; }
    public String getRoiDataJson() { return roiDataJson; }
    public void setRoiDataJson(String roiDataJson) { this.roiDataJson = roiDataJson; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
