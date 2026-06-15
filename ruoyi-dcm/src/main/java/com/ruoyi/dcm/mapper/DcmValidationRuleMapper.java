package com.ruoyi.dcm.mapper;

import java.util.List;
import com.ruoyi.dcm.domain.DcmValidationRule;

public interface DcmValidationRuleMapper
{
    List<DcmValidationRule> selectDcmValidationRuleList(DcmValidationRule rule);

    List<DcmValidationRule> selectEnabledTypeOneRules(String sopClassUid);

    DcmValidationRule selectDcmValidationRuleById(Long ruleId);

    int insertDcmValidationRule(DcmValidationRule rule);

    int updateDcmValidationRule(DcmValidationRule rule);

    int deleteDcmValidationRuleByIds(Long[] ruleIds);
}
