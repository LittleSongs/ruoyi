package com.ruoyi.ndt.uid;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.uid.domain.NdtUidRule;
import com.ruoyi.ndt.uid.service.impl.NdtUidRuleServiceImpl;

class NdtUidRuleServiceImplTest
{
    @Test
    void generatesUuidBasedDicomUid()
    {
        NdtUidRuleServiceImpl service = new NdtUidRuleServiceImpl();
        NdtUidRule rule = new NdtUidRule();
        rule.setRootType(NdtConstants.UID_ROOT_TYPE_UUID_2_25);

        String uid = service.generateUid(rule, NdtConstants.UID_TYPE_STUDY);

        assertTrue(uid.matches("2\\.25\\.\\d+"));
        assertTrue(uid.length() <= 64);
    }

    @Test
    void generatesDifferentCustomRootUidsWithTypeTimestampAndRandomSuffix()
    {
        NdtUidRuleServiceImpl service = new NdtUidRuleServiceImpl();
        NdtUidRule rule = new NdtUidRule();
        rule.setRootType(NdtConstants.UID_ROOT_TYPE_CUSTOM_ROOT);
        rule.setUidRoot("1.2.826.0.1.3680043.10.543");
        rule.setSuffixPattern("{type}.{timestamp}.{random}");

        String first = service.generateUid(rule, NdtConstants.UID_TYPE_SERIES);
        String second = service.generateUid(rule, NdtConstants.UID_TYPE_SERIES);

        assertTrue(first.startsWith("1.2.826.0.1.3680043.10.543.SERIES."));
        assertTrue(first.length() <= 64);
        assertNotEquals(first, second);
    }

    @Test
    void fallsBackToUuidWhenCustomRootIsMissing()
    {
        NdtUidRuleServiceImpl service = new NdtUidRuleServiceImpl();
        NdtUidRule rule = new NdtUidRule();
        rule.setRootType(NdtConstants.UID_ROOT_TYPE_CUSTOM_ROOT);

        String uid = service.generateUid(rule, NdtConstants.UID_TYPE_SOP_INSTANCE);

        assertEquals("2.25.", uid.substring(0, 5));
    }
}
