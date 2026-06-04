package com.ruoyi.ndt.dicom;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.util.ReflectionTestUtils;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomPrivateTag;
import com.ruoyi.ndt.dicom.mapper.NdtDicomPrivateTagMapper;
import com.ruoyi.ndt.dicom.service.impl.NdtDicomPrivateTagServiceImpl;

class NdtDicomPrivateTagServiceImplTest
{
    @Mock
    private NdtDicomPrivateTagMapper privateTagMapper;

    private NdtDicomPrivateTagServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new NdtDicomPrivateTagServiceImpl();
        ReflectionTestUtils.setField(service, "privateTagMapper", privateTagMapper);
    }

    @Test
    void defaultAllowedTagsCoverRequestedBusinessLabels()
    {
        List<NdtDicomPrivateTag> defaults = NdtDicomPrivateTagServiceImpl.defaultPrivateTags();

        List<String> labels = defaults.stream().map(NdtDicomPrivateTag::getTagLabel).toList();
        assertTrue(labels.containsAll(Arrays.asList("制造商", "委托方", "检测人员", "评定结论")));
    }

    @Test
    void editableTagNamesComeOnlyFromEnabledConfiguredTags()
    {
        when(privateTagMapper.selectEnabledNdtDicomPrivateTagList()).thenReturn(Arrays.asList(
                tag("Manufacturer", "制造商", "0008,0070", NdtConstants.YES),
                tag("NdtClientName", "委托方", "0011,1010", NdtConstants.YES),
                tag("NDTDisabled", "停用项", NdtConstants.NO)));

        assertEquals(Arrays.asList("Manufacturer", "NdtClientName"), service.selectEditableTagNames());
        assertEquals("NdtClientName", service.selectEnabledTagByNameOrCode("0011,1010").getTagName());
    }

    @Test
    void saveRejectsUnsupportedTagNames()
    {
        when(privateTagMapper.selectEnabledNdtDicomPrivateTagList()).thenReturn(List.of(
                tag("Manufacturer", "制造商", "0008,0070", NdtConstants.YES)));

        ServiceException ex = assertThrows(ServiceException.class, () -> service.checkEditableTagName("0011,1012"));

        assertEquals("不允许编辑未配置或未启用的DICOM标签：0011,1012", ex.getMessage());
    }

    private NdtDicomPrivateTag tag(String tagName, String tagLabel, String enabled)
    {
        return tag(tagName, tagLabel, null, enabled);
    }

    private NdtDicomPrivateTag tag(String tagName, String tagLabel, String tagCode, String enabled)
    {
        NdtDicomPrivateTag tag = new NdtDicomPrivateTag();
        tag.setTagName(tagName);
        tag.setTagLabel(tagLabel);
        tag.setTagCode(tagCode);
        tag.setEnabled(enabled);
        return tag;
    }
}
