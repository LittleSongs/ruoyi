package com.ruoyi.ndt.dicom.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Orthanc hierarchy node for study/series/instance visualization.
 */
public class NdtOrthancHierarchyNode implements Serializable
{
    private static final long serialVersionUID = 1L;

    private String id;
    private String parentId;
    private String nodeType;
    private String title;
    private String orthancId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;
    private Integer childCount;
    private List<NdtOrthancHierarchyNode> children = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }
    public String getNodeType() { return nodeType; }
    public void setNodeType(String nodeType) { this.nodeType = nodeType; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getOrthancId() { return orthancId; }
    public void setOrthancId(String orthancId) { this.orthancId = orthancId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public Integer getChildCount() { return childCount; }
    public void setChildCount(Integer childCount) { this.childCount = childCount; }
    public List<NdtOrthancHierarchyNode> getChildren() { return children; }
    public void setChildren(List<NdtOrthancHierarchyNode> children) { this.children = children; }
}
