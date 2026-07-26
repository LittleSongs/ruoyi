package com.ruoyi.ndt.organization.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

public class NdtObjectTreeItem
{
    private Long id;
    private String objectType;
    private String label;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;
    private String seriesNumber;
    private String instanceNumber;
    private String seriesDescription;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getId() { return id; }
    public void setId(Long value) { this.id = value; }
    public String getObjectType() { return objectType; }
    public void setObjectType(String value) { this.objectType = value; }
    public String getLabel() { return label; }
    public void setLabel(String value) { this.label = value; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String value) { this.studyInstanceUid = value; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String value) { this.seriesInstanceUid = value; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String value) { this.sopInstanceUid = value; }
    public String getModality() { return modality; }
    public void setModality(String value) { this.modality = value; }
    public String getSeriesNumber() { return seriesNumber; }
    public void setSeriesNumber(String value) { this.seriesNumber = value; }
    public String getInstanceNumber() { return instanceNumber; }
    public void setInstanceNumber(String value) { this.instanceNumber = value; }
    public String getSeriesDescription() { return seriesDescription; }
    public void setSeriesDescription(String value) { this.seriesDescription = value; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date value) { this.createTime = value; }
}
