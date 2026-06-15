package com.ruoyi.dcm.service;

import java.util.List;
import com.ruoyi.dcm.domain.DcmValidationRule;

public interface IDcmValidationRuleService
{
    List<DcmValidationRule> selectDcmValidationRuleList(DcmValidationRule rule);

    DcmValidationRule selectDcmValidationRuleById(Long ruleId);

    int insertDcmValidationRule(DcmValidationRule rule, String username);

    int updateDcmValidationRule(DcmValidationRule rule, String username);

    int deleteDcmValidationRuleByIds(Long[] ruleIds);
}
