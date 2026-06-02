package com.ruoyi.ndt.dicom.domain;

import java.io.Serializable;

/**
 * DICOM tag item for viewing/editing.
 */
public class NdtDicomTagItem implements Serializable
{
    private static final long serialVersionUID = 1L;

    private String tagName;
    private String vr;
    private String value;
    private String originalValue;
    private Boolean editable;

    public String getTagName()
    {
        return tagName;
    }

    public void setTagName(String tagName)
    {
        this.tagName = tagName;
    }

    public String getVr()
    {
        return vr;
    }

    public void setVr(String vr)
    {
        this.vr = vr;
    }

    public String getValue()
    {
        return value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    public String getOriginalValue()
    {
        return originalValue;
    }

    public void setOriginalValue(String originalValue)
    {
        this.originalValue = originalValue;
    }

    public Boolean getEditable()
    {
        return editable;
    }

    public void setEditable(Boolean editable)
    {
        this.editable = editable;
    }
}
