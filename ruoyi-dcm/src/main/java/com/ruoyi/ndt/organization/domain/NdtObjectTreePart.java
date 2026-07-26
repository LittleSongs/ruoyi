package com.ruoyi.ndt.organization.domain;

import java.util.ArrayList;
import java.util.List;

public class NdtObjectTreePart
{
    private Long id;
    private String partNo;
    private String partName;
    private Long sourceDicomInstanceId;
    private String sourceSopInstanceUid;
    private List<NdtObjectTreeItem> objects = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long value) { this.id = value; }
    public String getPartNo() { return partNo; }
    public void setPartNo(String value) { this.partNo = value; }
    public String getPartName() { return partName; }
    public void setPartName(String value) { this.partName = value; }
    public Long getSourceDicomInstanceId() { return sourceDicomInstanceId; }
    public void setSourceDicomInstanceId(Long value) { this.sourceDicomInstanceId = value; }
    public String getSourceSopInstanceUid() { return sourceSopInstanceUid; }
    public void setSourceSopInstanceUid(String value) { this.sourceSopInstanceUid = value; }
    public List<NdtObjectTreeItem> getObjects() { return objects; }
    public void setObjects(List<NdtObjectTreeItem> value) { this.objects = value; }
}
