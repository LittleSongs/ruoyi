package com.ruoyi.dcm.validation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import com.ruoyi.dcm.domain.DcmValidationRule;
import com.ruoyi.dcm.mapper.DcmValidationRuleMapper;

class DcmCustomRuleValidatorTest
{
    @Mock
    private DcmValidationRuleMapper ruleMapper;

    private DcmCustomRuleValidator validator;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        validator = new DcmCustomRuleValidator();
        org.springframework.test.util.ReflectionTestUtils.setField(validator, "ruleMapper", ruleMapper);
    }

    @Test
    void validatesRequiredTagRulesForSpecificAndWildcardSopClass()
    {
        DcmDicomMetadata metadata = new DcmDicomMetadata();
        metadata.setSopClassUid("1.2.840.10008.5.1.4.1.1.2");
        metadata.putTagValue("00080016", "1.2.840.10008.5.1.4.1.1.2");

        when(ruleMapper.selectEnabledTypeOneRules("1.2.840.10008.5.1.4.1.1.2")).thenReturn(List.of(
                rule(1L, "通用SOPClassUID", "*", "00080016", "(0008,0016)", "SOPClassUID", "N"),
                rule(2L, "CT私有客户", "1.2.840.10008.5.1.4.1.1.2", "00111010", "(0011,1010)", "NDTClientName", "N")));

        DcmCustomValidationResult result = validator.validate(metadata);

        assertEquals("FAIL", result.getStatus());
        assertEquals(1, result.getErrors().size());
        assertTrue(result.getErrors().get(0).getMessage().contains("(0011,1010)"));
    }

    @Test
    void allowsBlankWhenRuleAllowsBlankButStillRequiresTagPresence()
    {
        DcmDicomMetadata metadata = new DcmDicomMetadata();
        metadata.setSopClassUid("1.2.3");
        metadata.putTagValue("00111010", "");

        when(ruleMapper.selectEnabledTypeOneRules("1.2.3")).thenReturn(List.of(
                rule(3L, "可空私有Tag", "*", "00111010", "(0011,1010)", "NDTClientName", "Y")));

        DcmCustomValidationResult result = validator.validate(metadata);

        assertEquals("PASS", result.getStatus());
        assertEquals(0, result.getErrors().size());
    }

    private DcmValidationRule rule(Long id, String name, String sopClassUid, String tagCode,
            String tagDisplay, String tagName, String allowBlank)
    {
        DcmValidationRule rule = new DcmValidationRule();
        rule.setRuleId(id);
        rule.setRuleName(name);
        rule.setSopClassUid(sopClassUid);
        rule.setRuleType(1);
        rule.setTagCode(tagCode);
        rule.setTagDisplay(tagDisplay);
        rule.setTagName(tagName);
        rule.setAllowBlank(allowBlank);
        rule.setSeverity("ERROR");
        return rule;
    }
}
