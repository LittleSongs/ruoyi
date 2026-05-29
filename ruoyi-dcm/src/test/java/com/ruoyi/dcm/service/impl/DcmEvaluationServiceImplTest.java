package com.ruoyi.dcm.service.impl;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.util.ReflectionTestUtils;
import com.ruoyi.dcm.constants.DcmConstants;
import com.ruoyi.dcm.domain.DcmEvaluation;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.mapper.DcmEvaluationMapper;
import com.ruoyi.dcm.mapper.DcmStudyMapper;

class DcmEvaluationServiceImplTest
{
    @Mock
    private DcmEvaluationMapper evaluationMapper;

    @Mock
    private DcmStudyMapper studyMapper;

    private DcmEvaluationServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new DcmEvaluationServiceImpl();
        ReflectionTestUtils.setField(service, "evaluationMapper", evaluationMapper);
        ReflectionTestUtils.setField(service, "studyMapper", studyMapper);
    }

    @Test
    void submittedEvaluationMarksStudyEvaluated()
    {
        DcmStudy study = new DcmStudy();
        study.setId(1L);
        DcmEvaluation evaluation = new DcmEvaluation();
        evaluation.setStudyId(1L);
        evaluation.setEvaluationStatus(DcmConstants.EVALUATION_STATUS_SUBMITTED);
        when(studyMapper.selectDcmStudyById(1L)).thenReturn(study);
        when(evaluationMapper.insertDcmEvaluation(evaluation)).thenReturn(1);

        service.saveDcmEvaluation(evaluation, 7L, "evaluator");

        assertNotNull(evaluation.getEvaluationTime());
        verify(studyMapper).updateDcmStudyStatus(1L, DcmConstants.STUDY_STATUS_EVALUATED, "evaluator");
    }

    @Test
    void deletedEvaluationResetsStudyToUploaded()
    {
        DcmEvaluation evaluation = new DcmEvaluation();
        evaluation.setId(4L);
        evaluation.setStudyId(1L);
        when(evaluationMapper.selectDcmEvaluationById(4L)).thenReturn(evaluation);
        when(evaluationMapper.softDeleteDcmEvaluationByIds(new Long[] { 4L })).thenReturn(1);

        service.deleteDcmEvaluationByIds(new Long[] { 4L }, "operator");

        verify(studyMapper).updateDcmStudyStatus(1L, DcmConstants.STUDY_STATUS_UPLOADED, "operator");
    }
}
