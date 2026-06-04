package com.ruoyi.ndt.dicom.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Configurable DICOM tag that NDT users may add or edit.
 */
public class NdtDicomPrivateTag extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String tagName;
    private String tagLabel;
    private String tagCode;
    private String vr;
    private String defaultValue;
    private String enabled;
    private String builtin;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
    public String getTagLabel() { return tagLabel; }
    public void setTagLabel(String tagLabel) { this.tagLabel = tagLabel; }
    public String getTagCode() { return tagCode; }
    public void setTagCode(String tagCode) { this.tagCode = tagCode; }
    public String getVr() { return vr; }
    public void setVr(String vr) { this.vr = vr; }
    public String getDefaultValue() { return defaultValue; }
    public void setDefaultValue(String defaultValue) { this.defaultValue = defaultValue; }
    public String getEnabled() { return enabled; }
    public void setEnabled(String enabled) { this.enabled = enabled; }
    public String getBuiltin() { return builtin; }
    public void setBuiltin(String builtin) { this.builtin = builtin; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
