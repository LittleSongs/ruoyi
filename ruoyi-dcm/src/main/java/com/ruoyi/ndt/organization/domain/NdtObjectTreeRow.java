package com.ruoyi.ndt.organization.domain;

import java.util.Date;

public class NdtObjectTreeRow
{
    private Long partId;
    private String partNo;
    private String partName;
    private Long sourceDicomInstanceId;
    private String sourceSopInstanceUid;
    private Long dicomInstanceId;
    private String objectType;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;
    private String seriesNumber;
    private String instanceNumber;
    private String seriesDescription;
    private Date createTime;

    public Long getPartId() { return partId; }
    public void setPartId(Long value) { this.partId = value; }
    public String getPartNo() { return partNo; }
    public void setPartNo(String value) { this.partNo = value; }
    public String getPartName() { return partName; }
    public void setPartName(String value) { this.partName = value; }
    public Long getSourceDicomInstanceId() { return sourceDicomInstanceId; }
    public void setSourceDicomInstanceId(Long value) { this.sourceDicomInstanceId = value; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String value) { this.sourceSopInstanceUid = value; }
    public Long getDicomInstanceId() { return dicomInstanceId; }
    public void setDicomInstanceId(Long value) { this.dicomInstanceId = value; }
    public String getObjectType() { return objectType; }
    public void setObjectType(String value) { this.objectType = value; }
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
