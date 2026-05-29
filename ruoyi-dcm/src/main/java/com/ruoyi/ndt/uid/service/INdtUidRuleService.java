package com.ruoyi.ndt.uid.service;

import java.util.List;
import com.ruoyi.ndt.uid.domain.NdtUidRule;

public interface INdtUidRuleService
{
    List<NdtUidRule> selectNdtUidRuleList(NdtUidRule rule);

    NdtUidRule selectNdtUidRuleById(Long id);

    int insertNdtUidRule(NdtUidRule rule);

    int updateNdtUidRule(NdtUidRule rule);

    int deleteNdtUidRuleByIds(Long[] ids);

    String generateUid(String uidType, Long ruleId);
}
