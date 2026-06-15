package com.ruoyi.dcm.validation;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.domain.DcmValidationRule;
import com.ruoyi.dcm.mapper.DcmValidationRuleMapper;

@Component
public class DcmCustomRuleValidator
{
    @Autowired
    private DcmValidationRuleMapper ruleMapper;

    public DcmCustomValidationResult validate(DcmDicomMetadata metadata)
    {
        DcmCustomValidationResult result = new DcmCustomValidationResult();
        List<DcmValidationRule> rules = ruleMapper.selectEnabledTypeOneRules(metadata.getSopClassUid());
        for (DcmValidationRule rule : rules)
        {
            DcmValidationFailure failure = validateRule(metadata, rule);
            if (failure == null)
            {
                continue;
            }
            if ("WARNING".equalsIgnoreCase(failure.getSeverity()))
            {
                result.getWarnings().add(failure);
            }
            else
            {
                result.getErrors().add(failure);
            }
        }
        result.setStatus(result.getErrors().isEmpty() ? "PASS" : "FAIL");
        return result;
    }

    private DcmValidationFailure validateRule(DcmDicomMetadata metadata, DcmValidationRule rule)
    {
        String tagCode = DcmDicomMetadata.normalizeTagCode(rule.getTagCode());
        boolean exists = metadata.containsTag(tagCode);
        String actualValue = metadata.getTagValue(tagCode);
        boolean blank = StringUtils.isEmpty(actualValue);
        if (exists && ("Y".equalsIgnoreCase(rule.getAllowBlank()) || !blank))
        {
            return null;
        }
        DcmValidationFailure failure = new DcmValidationFailure();
        failure.setRuleId(rule.getRuleId());
        failure.setRuleName(rule.getRuleName());
        failure.setRuleType(rule.getRuleType());
        failure.setTagCode(tagCode);
        failure.setTagDisplay(rule.getTagDisplay());
        failure.setTagName(rule.getTagName());
        failure.setSeverity(StringUtils.isEmpty(rule.getSeverity()) ? "ERROR" : rule.getSeverity());
        failure.setActualValue(actualValue);
        failure.setMessage(message(rule, exists));
        return failure;
    }

    private String message(DcmValidationRule rule, boolean exists)
    {
        if (StringUtils.isNotEmpty(rule.getFailMessage()))
        {
            return rule.getFailMessage();
        }
        String tag = rule.getTagDisplay() + (StringUtils.isNotEmpty(rule.getTagName()) ? " " + rule.getTagName() : "");
        return exists ? "必备Tag值不能为空：" + tag : "缺少必备Tag：" + tag;
    }
}
