package com.ruoyi.ndt.study;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;
import com.ruoyi.ndt.study.service.impl.NdtInspectionStudyServiceImpl;
import com.ruoyi.ndt.study.vo.NdtStudyViewerContextVo;

class NdtInspectionStudyServiceTest
{
    private NdtInspectionStudyMapper mapper;
    private NdtAccessService access;
    private NdtInspectionStudyServiceImpl service;

    @BeforeEach
    void setUp()
    {
        mapper = mock(NdtInspectionStudyMapper.class);
        access = mock(NdtAccessService.class);
        service = new NdtInspectionStudyServiceImpl(mapper, access, new NdtProperties());
    }

    @Test
    void resolvesViewerContextFromStudyInstanceUid()
    {
        NdtInspectionStudy study = new NdtInspectionStudy();
        study.setId(2002L);
        study.setTaskId(1001L);
        study.setStudyInstanceUid("1.2.840.10008");
        when(mapper.selectByStudyInstanceUid("1.2.840.10008")).thenReturn(study);
        when(access.canEvaluateTask(1001L)).thenReturn(true);

        NdtStudyViewerContextVo context =
                service.getViewerContextByStudyInstanceUid("1.2.840.10008");

        assertEquals(1001L, context.getTaskId());
        assertEquals(2002L, context.getStudyId());
        assertEquals(true, context.getCanEvaluate());
        verify(access).checkViewTask(1001L);
    }
}
