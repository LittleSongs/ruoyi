package com.ruoyi.dcm.validation;

public class DcmValidationFailure
{
    private Long ruleId;
    private String ruleName;
    private Integer ruleType;
    private String tagCode;
    private String tagDisplay;
    private String tagName;
    private String severity;
    private String message;
    private String actualValue;

    public Long getRuleId() { return ruleId; }
    public void setRuleId(Long ruleId) { this.ruleId = ruleId; }
    public String getRuleName() { return ruleName; }
    public void setRuleName(String ruleName) { this.ruleName = ruleName; }
    public Integer getRuleType() { return ruleType; }
    public void setRuleType(Integer ruleType) { this.ruleType = ruleType; }
    public String getTagCode() { return tagCode; }
    public void setTagCode(String tagCode) { this.tagCode = tagCode; }
    public String getTagDisplay() { return tagDisplay; }
    public void setTagDisplay(String tagDisplay) { this.tagDisplay = tagDisplay; }
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getActualValue() { return actualValue; }
    public void setActualValue(String actualValue) { this.actualValue = actualValue; }
}
