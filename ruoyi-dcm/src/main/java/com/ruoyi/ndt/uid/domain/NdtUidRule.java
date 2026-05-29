package com.ruoyi.ndt.uid.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * NDT UID generation rule.
 */
public class NdtUidRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String ruleName;
    private String uidType;
    private String rootType;
    private String uidRoot;
    private String suffixPattern;
    private String enabled;
    private String delFlag;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getRuleName()
    {
        return ruleName;
    }

    public void setRuleName(String ruleName)
    {
        this.ruleName = ruleName;
    }

    public String getUidType()
    {
        return uidType;
    }

    public void setUidType(String uidType)
    {
        this.uidType = uidType;
    }

    public String getRootType()
    {
        return rootType;
    }

    public void setRootType(String rootType)
    {
        this.rootType = rootType;
    }

    public String getUidRoot()
    {
        return uidRoot;
    }

    public void setUidRoot(String uidRoot)
    {
        this.uidRoot = uidRoot;
    }

    public String getSuffixPattern()
    {
        return suffixPattern;
    }

    public void setSuffixPattern(String suffixPattern)
    {
        this.suffixPattern = suffixPattern;
    }

    public String getEnabled()
    {
        return enabled;
    }

    public void setEnabled(String enabled)
    {
        this.enabled = enabled;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }
}
