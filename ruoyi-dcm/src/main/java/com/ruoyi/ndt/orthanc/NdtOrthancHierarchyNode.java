package com.ruoyi.ndt.orthanc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Orthanc hierarchy node for UI rendering.
 */
public class NdtOrthancHierarchyNode implements Serializable
{
    private static final long serialVersionUID = 1L;

    private String id;
    private String parentId;
    private String nodeType;
    private String title;
    private String subtitle;
    private String orthancId;
    private Long dicomInstanceId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String modality;
    private String seriesNumber;
    private String instanceNumber;
    private Boolean leaf;
    private List<NdtOrthancHierarchyNode> children = new ArrayList<>();

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getParentId()
    {
        return parentId;
    }

    public void setParentId(String parentId)
    {
        this.parentId = parentId;
    }

    public String getNodeType()
    {
        return nodeType;
    }

    public void setNodeType(String nodeType)
    {
        this.nodeType = nodeType;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getSubtitle()
    {
        return subtitle;
    }

    public void setSubtitle(String subtitle)
    {
        this.subtitle = subtitle;
    }

    public String getOrthancId()
    {
        return orthancId;
    }

    public void setOrthancId(String orthancId)
    {
        this.orthancId = orthancId;
    }

    public Long getDicomInstanceId()
    {
        return dicomInstanceId;
    }

    public void setDicomInstanceId(Long dicomInstanceId)
    {
        this.dicomInstanceId = dicomInstanceId;
    }

    public String getStudyInstanceUid()
    {
        return studyInstanceUid;
    }

    public void setStudyInstanceUid(String studyInstanceUid)
    {
        this.studyInstanceUid = studyInstanceUid;
    }

    public String getSeriesInstanceUid()
    {
        return seriesInstanceUid;
    }

    public void setSeriesInstanceUid(String seriesInstanceUid)
    {
        this.seriesInstanceUid = seriesInstanceUid;
    }

    public String getSopInstanceUid()
    {
        return sopInstanceUid;
    }

    public void setSopInstanceUid(String sopInstanceUid)
    {
        this.sopInstanceUid = sopInstanceUid;
    }

    public String getModality()
    {
        return modality;
    }

    public void setModality(String modality)
    {
        this.modality = modality;
    }

    public String getSeriesNumber()
    {
        return seriesNumber;
    }

    public void setSeriesNumber(String seriesNumber)
    {
        this.seriesNumber = seriesNumber;
    }

    public String getInstanceNumber()
    {
        return instanceNumber;
    }

    public void setInstanceNumber(String instanceNumber)
    {
        this.instanceNumber = instanceNumber;
    }

    public Boolean getLeaf()
    {
        return leaf;
    }

    public void setLeaf(Boolean leaf)
    {
        this.leaf = leaf;
    }

    public List<NdtOrthancHierarchyNode> getChildren()
    {
        return children;
    }

    public void setChildren(List<NdtOrthancHierarchyNode> children)
    {
        this.children = children;
    }
}
