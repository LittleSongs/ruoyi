package com.ruoyi.ndt.uid.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.uid.domain.NdtUidRule;

public interface NdtUidRuleMapper
{
    List<NdtUidRule> selectNdtUidRuleList(NdtUidRule rule);

    NdtUidRule selectNdtUidRuleById(Long id);

    NdtUidRule selectEnabledNdtUidRuleByType(String uidType);

    int insertNdtUidRule(NdtUidRule rule);

    int updateNdtUidRule(NdtUidRule rule);

    int softDeleteNdtUidRuleByIds(Long[] ids);

    int disableOtherRules(@Param("id") Long id, @Param("uidType") String uidType, @Param("updateBy") String updateBy);
}
