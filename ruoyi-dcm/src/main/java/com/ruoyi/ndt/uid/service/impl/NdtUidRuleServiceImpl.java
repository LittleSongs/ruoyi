package com.ruoyi.ndt.uid.service.impl;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.uid.domain.NdtUidRule;
import com.ruoyi.ndt.uid.mapper.NdtUidRuleMapper;
import com.ruoyi.ndt.uid.service.INdtUidRuleService;

@Service
public class NdtUidRuleServiceImpl implements INdtUidRuleService
{
    private static final SecureRandom RANDOM = new SecureRandom();

    @Autowired(required = false)
    private NdtUidRuleMapper uidRuleMapper;

    @Override
    public List<NdtUidRule> selectNdtUidRuleList(NdtUidRule rule)
    {
        return uidRuleMapper.selectNdtUidRuleList(rule);
    }

    @Override
    public NdtUidRule selectNdtUidRuleById(Long id)
    {
        return uidRuleMapper.selectNdtUidRuleById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertNdtUidRule(NdtUidRule rule)
    {
        normalize(rule);
        int rows = uidRuleMapper.insertNdtUidRule(rule);
        disableOtherEnabledRules(rule);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNdtUidRule(NdtUidRule rule)
    {
        normalize(rule);
        int rows = uidRuleMapper.updateNdtUidRule(rule);
        disableOtherEnabledRules(rule);
        return rows;
    }

    @Override
    public int deleteNdtUidRuleByIds(Long[] ids)
    {
        return uidRuleMapper.softDeleteNdtUidRuleByIds(ids);
    }

    @Override
    public String generateUid(String uidType, Long ruleId)
    {
        NdtUidRule rule = ruleId == null ? uidRuleMapper.selectEnabledNdtUidRuleByType(uidType)
                : uidRuleMapper.selectNdtUidRuleById(ruleId);
        return generateUid(rule, uidType);
    }

    public String generateUid(NdtUidRule rule, String uidType)
    {
        if (rule == null || NdtConstants.UID_ROOT_TYPE_UUID_2_25.equals(rule.getRootType())
                || StringUtils.isEmpty(rule.getUidRoot()))
        {
            return uuid225Uid();
        }
        if (!NdtConstants.UID_ROOT_TYPE_CUSTOM_ROOT.equals(rule.getRootType()))
        {
            return uuid225Uid();
        }
        String root = trimDot(rule.getUidRoot());
        String pattern = StringUtils.isEmpty(rule.getSuffixPattern()) ? "{timestamp}.{random}" : rule.getSuffixPattern();
        String suffix = pattern.replace("{type}", uidType == null ? "UID" : uidType)
                .replace("{timestamp}", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()))
                .replace("{random}", randomDigits(8));
        return limitUid(root + "." + trimDot(suffix));
    }

    private void normalize(NdtUidRule rule)
    {
        if (StringUtils.isEmpty(rule.getRuleName()))
        {
            throw new ServiceException("规则名称不能为空");
        }
        if (StringUtils.isEmpty(rule.getUidType()))
        {
            throw new ServiceException("UID类型不能为空");
        }
        if (StringUtils.isEmpty(rule.getRootType()))
        {
            rule.setRootType(NdtConstants.UID_ROOT_TYPE_UUID_2_25);
        }
        if (NdtConstants.UID_ROOT_TYPE_CUSTOM_ROOT.equals(rule.getRootType()))
        {
            validateSuffixPattern(rule.getSuffixPattern());
        }
        if (StringUtils.isEmpty(rule.getEnabled()))
        {
            rule.setEnabled(NdtConstants.YES);
        }
        rule.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
    }

    private void validateSuffixPattern(String suffixPattern)
    {
        if (StringUtils.isEmpty(suffixPattern) || !suffixPattern.contains("{random}"))
        {
            throw new ServiceException("后缀模式必须包含至少一个{random}");
        }
    }

    private void disableOtherEnabledRules(NdtUidRule rule)
    {
        if (NdtConstants.YES.equals(rule.getEnabled()) && rule.getId() != null)
        {
            uidRuleMapper.disableOtherRules(rule.getId(), rule.getUidType(), rule.getUpdateBy());
        }
    }

    private String uuid225Uid()
    {
        UUID uuid = UUID.randomUUID();
        byte[] bytes = new byte[16];
        long most = uuid.getMostSignificantBits();
        long least = uuid.getLeastSignificantBits();
        for (int i = 0; i < 8; i++)
        {
            bytes[i] = (byte) (most >>> (8 * (7 - i)));
            bytes[i + 8] = (byte) (least >>> (8 * (7 - i)));
        }
        return "2.25." + new BigInteger(1, bytes).toString();
    }

    private String randomDigits(int length)
    {
        StringBuilder value = new StringBuilder(length);
        for (int i = 0; i < length; i++)
        {
            value.append(RANDOM.nextInt(10));
        }
        return value.toString();
    }

    private String trimDot(String value)
    {
        if (value == null)
        {
            return "";
        }
        return value.replaceAll("^\\.+|\\.+$", "");
    }

    private String limitUid(String uid)
    {
        if (uid.length() <= 64)
        {
            return uid;
        }
        int lastDot = uid.lastIndexOf('.', 63);
        return lastDot > 0 ? uid.substring(0, lastDot) : uid.substring(0, 64);
    }
}
