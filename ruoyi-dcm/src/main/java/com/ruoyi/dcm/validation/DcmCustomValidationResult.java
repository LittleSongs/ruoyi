package com.ruoyi.dcm.validation;

import java.util.ArrayList;
import java.util.List;

public class DcmCustomValidationResult
{
    private String status = "PASS";
    private Integer ruleType = 1;
    private List<DcmValidationFailure> errors = new ArrayList<>();
    private List<DcmValidationFailure> warnings = new ArrayList<>();

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getRuleType() { return ruleType; }
    public void setRuleType(Integer ruleType) { this.ruleType = ruleType; }
    public List<DcmValidationFailure> getErrors() { return errors; }
    public void setErrors(List<DcmValidationFailure> errors) { this.errors = errors; }
    public List<DcmValidationFailure> getWarnings() { return warnings; }
    public void setWarnings(List<DcmValidationFailure> warnings) { this.warnings = warnings; }
}
