package com.ruoyi.dcm.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.dcm.domain.DcmValidationRule;
import com.ruoyi.dcm.mapper.DcmValidationRuleMapper;
import com.ruoyi.dcm.service.IDcmValidationRuleService;

@Service
public class DcmValidationRuleServiceImpl implements IDcmValidationRuleService
{
    private static final int REQUIRED_TAG_RULE = 1;

    @Autowired
    private DcmValidationRuleMapper ruleMapper;

    @Override
    public List<DcmValidationRule> selectDcmValidationRuleList(DcmValidationRule rule)
    {
        return ruleMapper.selectDcmValidationRuleList(rule);
    }

    @Override
    public DcmValidationRule selectDcmValidationRuleById(Long ruleId)
    {
        return ruleMapper.selectDcmValidationRuleById(ruleId);
    }

    @Override
    public int insertDcmValidationRule(DcmValidationRule rule, String username)
    {
        normalize(rule);
        rule.setCreateBy(username);
        rule.setUpdateBy(username);
        return ruleMapper.insertDcmValidationRule(rule);
    }

    @Override
    public int updateDcmValidationRule(DcmValidationRule rule, String username)
    {
        if (rule.getRuleId() == null)
        {
            throw new ServiceException("校验规则ID不能为空");
        }
        normalize(rule);
        rule.setUpdateBy(username);
        return ruleMapper.updateDcmValidationRule(rule);
    }

    @Override
    public int deleteDcmValidationRuleByIds(Long[] ruleIds)
    {
        return ruleMapper.deleteDcmValidationRuleByIds(ruleIds);
    }

    private void normalize(DcmValidationRule rule)
    {
        if (StringUtils.isEmpty(rule.getRuleName()))
        {
            throw new ServiceException("规则名称不能为空");
        }
        if (StringUtils.isEmpty(rule.getSopClassUid()))
        {
            rule.setSopClassUid("*");
        }
        if (rule.getRuleType() == null)
        {
            rule.setRuleType(REQUIRED_TAG_RULE);
        }
        if (!Integer.valueOf(REQUIRED_TAG_RULE).equals(rule.getRuleType()))
        {
            throw new ServiceException("第一版仅支持必备Tag规则");
        }
        if (StringUtils.isEmpty(rule.getTagCode()))
        {
            throw new ServiceException("Tag编号不能为空");
        }
        rule.setTagCode(rule.getTagCode().replace("(", "").replace(")", "").replace(",", "").replace(" ", "").toUpperCase());
        if (rule.getTagCode().length() != 8)
        {
            throw new ServiceException("Tag编号必须为8位十六进制格式，例如00080016");
        }
        if (StringUtils.isEmpty(rule.getTagDisplay()))
        {
            String tagCode = rule.getTagCode();
            rule.setTagDisplay("(" + tagCode.substring(0, 4) + "," + tagCode.substring(4) + ")");
        }
        if (StringUtils.isEmpty(rule.getAllowBlank()))
        {
            rule.setAllowBlank("N");
        }
        if (StringUtils.isEmpty(rule.getSeverity()))
        {
            rule.setSeverity("ERROR");
        }
        if (StringUtils.isEmpty(rule.getEnabled()))
        {
            rule.setEnabled("Y");
        }
        if (rule.getSortOrder() == null)
        {
            rule.setSortOrder(0);
        }
    }
}
