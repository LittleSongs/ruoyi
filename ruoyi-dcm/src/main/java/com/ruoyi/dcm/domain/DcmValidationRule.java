package com.ruoyi.dcm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Configurable DICOM validation rule.
 */
public class DcmValidationRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long ruleId;
    private String ruleName;
    private String sopClassUid;
    private String sopName;
    private String modality;
    private Integer ruleType;
    private String tagCode;
    private String tagDisplay;
    private String tagName;
    private String vr;
    private String privateCreator;
    private String allowBlank;
    private String severity;
    private String enabled;
    private Integer sortOrder;
    private String failMessage;

    public Long getRuleId() { return ruleId; }
    public void setRuleId(Long ruleId) { this.ruleId = ruleId; }
    public String getRuleName() { return ruleName; }
    public void setRuleName(String ruleName) { this.ruleName = ruleName; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getSopName() { return sopName; }
    public void setSopName(String sopName) { this.sopName = sopName; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public Integer getRuleType() { return ruleType; }
    public void setRuleType(Integer ruleType) { this.ruleType = ruleType; }
    public String getTagCode() { return tagCode; }
    public void setTagCode(String tagCode) { this.tagCode = tagCode; }
    public String getTagDisplay() { return tagDisplay; }
    public void setTagDisplay(String tagDisplay) { this.tagDisplay = tagDisplay; }
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
    public String getVr() { return vr; }
    public void setVr(String vr) { this.vr = vr; }
    public String getPrivateCreator() { return privateCreator; }
    public void setPrivateCreator(String privateCreator) { this.privateCreator = privateCreator; }
    public String getAllowBlank() { return allowBlank; }
    public void setAllowBlank(String allowBlank) { this.allowBlank = allowBlank; }
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    public String getEnabled() { return enabled; }
    public void setEnabled(String enabled) { this.enabled = enabled; }
    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
    public String getFailMessage() { return failMessage; }
    public void setFailMessage(String failMessage) { this.failMessage = failMessage; }
}
