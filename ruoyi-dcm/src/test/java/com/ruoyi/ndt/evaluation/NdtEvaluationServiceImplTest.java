package com.ruoyi.ndt.evaluation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.mapper.NdtEvaluationMapper;
import com.ruoyi.ndt.evaluation.service.impl.NdtEvaluationServiceImpl;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;

class NdtEvaluationServiceImplTest
{
    @Mock
    private NdtEvaluationMapper evaluationMapper;

    @Mock
    private NdtInspectionTaskMapper taskMapper;

    @Mock
    private OrthancService orthancService;

    @Mock
    private NdtDicomInstanceMapper dicomInstanceMapper;

    @Mock
    private NdtDicomObjectRelationMapper relationMapper;

    @Mock
    private INdtIntegrityService integrityService;

    private NdtEvaluationServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new NdtEvaluationServiceImpl();
        ReflectionTestUtils.setField(service, "evaluationMapper", evaluationMapper);
        ReflectionTestUtils.setField(service, "taskMapper", taskMapper);
        ReflectionTestUtils.setField(service, "orthancService", orthancService);
        ReflectionTestUtils.setField(service, "dicomInstanceMapper", dicomInstanceMapper);
        ReflectionTestUtils.setField(service, "objectRelationMapper", relationMapper);
        ReflectionTestUtils.setField(service, "integrityService", integrityService);
    }

    @Test
    void batchSubmitWithSrCreatesOneEvaluationPerDefectAndLinksAllToOneSr()
    {
        NdtInspectionTask task = new NdtInspectionTask();
        task.setId(1001L);
        task.setWorkpieceName("Pipe A");
        task.setCustomerDeptId(200L);
        when(taskMapper.selectNdtInspectionTaskById(1001L)).thenReturn(task);
        when(integrityService.calculateSha256(any())).thenReturn("abc123");
        when(orthancService.uploadInstance(any())).thenReturn(json("{\"ID\":\"orthanc-sr-1\"}"));
        when(orthancService.getInstance("orthanc-sr-1")).thenReturn(json("{\"ParentSeries\":\"orthanc-series-1\"}"));
        when(orthancService.getSeries("orthanc-series-1")).thenReturn(json("{\"ParentStudy\":\"orthanc-study-1\"}"));
        when(orthancService.getInstanceSimplifiedTags("orthanc-sr-1")).thenReturn(json("{"
                + "\"StudyInstanceUID\":\"study-uid\","
                + "\"SeriesInstanceUID\":\"sr-series-uid\","
                + "\"SOPInstanceUID\":\"sr-sop-uid\","
                + "\"SOPClassUID\":\"1.2.840.10008.5.1.4.1.1.88.22\","
                + "\"Modality\":\"SR\","
                + "\"SeriesDescription\":\"NDT SR\""
                + "}"));
        when(evaluationMapper.insertNdtEvaluation(any())).thenAnswer(invocation -> {
            NdtEvaluation evaluation = invocation.getArgument(0);
            evaluation.setId(evaluation.getDefectType().equals("裂纹") ? 11L : 12L);
            return 1;
        });
        when(dicomInstanceMapper.insertNdtDicomInstance(any())).thenAnswer(invocation -> {
            ((NdtDicomInstance) invocation.getArgument(0)).setId(31L);
            return 1;
        });

        NdtEvaluation first = evaluation("裂纹", "II级");
        NdtEvaluation second = evaluation("夹渣", "III级");
        MockMultipartFile srFile = new MockMultipartFile("srFile", "ndt-sr.dcm", "application/dicom",
                new byte[] { 1, 2, 3 });

        service.batchSubmitWithSr(1001L, Arrays.asList(first, second), srFile, "anonymous");

        ArgumentCaptor<NdtDicomObjectRelation> relationCaptor =
                ArgumentCaptor.forClass(NdtDicomObjectRelation.class);
        verify(evaluationMapper, times(2)).insertNdtEvaluation(any());
        verify(dicomInstanceMapper).insertNdtDicomInstance(any());
        verify(relationMapper, times(2)).insertNdtDicomObjectRelation(relationCaptor.capture());
        List<NdtDicomObjectRelation> relations = relationCaptor.getAllValues();
        assertEquals(11L, relations.get(0).getEvaluationId());
        assertEquals(12L, relations.get(1).getEvaluationId());
        assertEquals("sr-sop-uid", relations.get(0).getRelatedSopInstanceUid());
        assertEquals(NdtConstants.RELATED_TYPE_SR, relations.get(0).getRelatedType());
        verify(taskMapper).updateNdtInspectionTaskStatus(1001L, NdtConstants.TASK_STATUS_EVALUATED, "anonymous");
    }

    private NdtEvaluation evaluation(String defectType, String defectLevel)
    {
        NdtEvaluation evaluation = new NdtEvaluation();
        evaluation.setStudyInstanceUid("study-uid");
        evaluation.setSeriesInstanceUid("source-series-uid");
        evaluation.setSopInstanceUid("source-sop-uid");
        evaluation.setDefectType(defectType);
        evaluation.setDefectLevel(defectLevel);
        evaluation.setConclusion("不可接受");
        evaluation.setAnnotationJson("{}");
        return evaluation;
    }

    private JSONObject json(String value)
    {
        return JSONObject.parseObject(value);
    }
}
