package com.ruoyi.dcm.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.dcm.config.DcmProperties;
import com.ruoyi.dcm.constants.DcmConstants;
import com.ruoyi.dcm.domain.DcmInstance;
import com.ruoyi.dcm.domain.DcmSeries;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.domain.DcmUploadResult;
import com.ruoyi.dcm.mapper.DcmInstanceMapper;
import com.ruoyi.dcm.mapper.DcmSeriesMapper;
import com.ruoyi.dcm.mapper.DcmStudyMapper;
import com.ruoyi.dcm.service.DcmOrthancService;
import com.ruoyi.dcm.validation.DcmUploadValidationResult;
import com.ruoyi.dcm.validation.DcmUploadValidationService;

class DcmUploadServiceImplTest
{
    @Mock
    private DcmOrthancService orthancService;

    @Mock
    private DcmStudyMapper studyMapper;

    @Mock
    private DcmSeriesMapper seriesMapper;

    @Mock
    private DcmInstanceMapper instanceMapper;

    @Mock
    private DcmUploadValidationService validationService;

    private DcmUploadServiceImpl service;

    private MockMultipartFile file;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        DcmProperties properties = new DcmProperties();
        properties.getOhif().setViewerUrl("http://viewer/viewer");
        service = new DcmUploadServiceImpl();
        ReflectionTestUtils.setField(service, "orthancService", orthancService);
        ReflectionTestUtils.setField(service, "properties", properties);
        ReflectionTestUtils.setField(service, "studyMapper", studyMapper);
        ReflectionTestUtils.setField(service, "seriesMapper", seriesMapper);
        ReflectionTestUtils.setField(service, "instanceMapper", instanceMapper);
        ReflectionTestUtils.setField(service, "validationService", validationService);
        file = new MockMultipartFile("file", "test.dcm", "application/dicom", new byte[] { 1 });
        when(validationService.validate(any(), any(), any())).thenReturn(validationPass());
    }

    @Test
    void synchronizesAllSeriesAndInstancesInUploadedStudy()
    {
        arrangeHierarchy(true);
        when(studyMapper.insertDcmStudy(any())).thenAnswer(invocation -> {
            ((DcmStudy) invocation.getArgument(0)).setId(10L);
            return 1;
        });
        when(seriesMapper.insertDcmSeries(any())).thenAnswer(invocation -> {
            DcmSeries series = invocation.getArgument(0);
            series.setId("series-uid-1".equals(series.getSeriesInstanceUid()) ? 20L : 21L);
            return 1;
        });

        DcmUploadResult result = service.uploadAndSync(file, 1L, "admin");

        ArgumentCaptor<DcmStudy> studyCaptor = ArgumentCaptor.forClass(DcmStudy.class);
        verify(studyMapper).insertDcmStudy(studyCaptor.capture());
        assertEquals(2, studyCaptor.getValue().getSeriesCount());
        assertEquals(2, studyCaptor.getValue().getInstanceCount());
        verify(seriesMapper).softDeleteDcmSeriesByStudyId(10L);
        verify(instanceMapper).softDeleteDcmInstanceByStudyId(10L);
        verify(seriesMapper, times(2)).insertDcmSeries(any());
        verify(instanceMapper, times(2)).insertDcmInstance(any());
        assertEquals("http://viewer/viewer?StudyInstanceUIDs=study-uid", result.getOhifViewerUrl());
    }

    @Test
    void reuploadUpdatesExistingRowsAndKeepsEvaluatedStatus()
    {
        arrangeHierarchy(false);
        DcmStudy existingStudy = new DcmStudy();
        existingStudy.setId(10L);
        existingStudy.setStatus(DcmConstants.STUDY_STATUS_EVALUATED);
        existingStudy.setDelFlag(DcmConstants.DEL_FLAG_NORMAL);
        DcmSeries existingSeries = new DcmSeries();
        existingSeries.setId(20L);
        DcmInstance existingInstance = new DcmInstance();
        existingInstance.setId(30L);
        when(studyMapper.selectDcmStudyByUid("study-uid")).thenReturn(existingStudy);
        when(seriesMapper.selectDcmSeriesByUid("series-uid-1")).thenReturn(existingSeries);
        when(instanceMapper.selectDcmInstanceByUid("sop-uid-1")).thenReturn(existingInstance);

        service.uploadAndSync(file, 1L, "admin");

        verify(studyMapper, never()).insertDcmStudy(any());
        verify(seriesMapper, never()).insertDcmSeries(any());
        verify(instanceMapper, never()).insertDcmInstance(any());
        verify(studyMapper).updateDcmStudy(existingStudy);
        assertEquals(DcmConstants.STUDY_STATUS_EVALUATED, existingStudy.getStatus());
    }

    @Test
    void rejectsMissingCriticalUidWithReadableMessage()
    {
        when(orthancService.uploadInstance(file)).thenReturn(json("{\"ID\":\"i-1\"}"));
        when(orthancService.getInstance("i-1")).thenReturn(json("{\"ParentSeries\":\"s-1\"}"));
        when(orthancService.getSeries("s-1")).thenReturn(json("{\"ParentStudy\":\"study-1\"}"));
        when(orthancService.getStudy("study-1")).thenReturn(json("{\"Series\":[\"s-1\"]}"));
        when(orthancService.getInstanceSimplifiedTags("i-1")).thenReturn(json("{\"SeriesInstanceUID\":\"series-uid-1\",\"SOPInstanceUID\":\"sop-uid-1\"}"));

        ServiceException exception = assertThrows(ServiceException.class, () -> service.uploadAndSync(file, 1L, "admin"));

        assertEquals(true, exception.getMessage().contains("StudyInstanceUID"));
        verify(studyMapper, never()).insertDcmStudy(any());
    }

    @Test
    void validationFailureDoesNotUploadToOrthanc()
    {
        DcmUploadValidationResult validation = new DcmUploadValidationResult();
        validation.setRecordId(9L);
        validation.setFileName("bad.dcm");
        validation.setFinalStatus("FAIL");
        validation.setOfficialStatus("PASS");
        validation.setCustomStatus("FAIL");
        validation.getErrors().add("缺少必备Tag：(0011,1010) NDTClientName");
        when(validationService.validate(any(), any(), any())).thenReturn(validation);

        DcmUploadResult result = service.uploadAndSync(file, 1L, "admin");

        assertEquals("FAIL", result.getFinalStatus());
        verify(orthancService, never()).uploadInstance(any());
    }

    private void arrangeHierarchy(boolean includeSecondSeries)
    {
        String studyJson = includeSecondSeries ? "{\"Series\":[\"s-1\",\"s-2\"]}" : "{\"Series\":[\"s-1\"]}";
        when(orthancService.uploadInstance(file)).thenReturn(json("{\"ID\":\"i-1\"}"));
        when(orthancService.getInstance("i-1")).thenReturn(json("{\"ParentSeries\":\"s-1\"}"));
        when(orthancService.getStudy("study-1")).thenReturn(json(studyJson));
        when(orthancService.getSeries("s-1")).thenReturn(json("{\"ParentStudy\":\"study-1\",\"Instances\":[\"i-1\"]}"));
        when(orthancService.getInstanceSimplifiedTags("i-1")).thenReturn(tags("series-uid-1", "sop-uid-1"));
        if (includeSecondSeries)
        {
            when(orthancService.getSeries("s-2")).thenReturn(json("{\"ParentStudy\":\"study-1\",\"Instances\":[\"i-2\"]}"));
            when(orthancService.getInstanceSimplifiedTags("i-2")).thenReturn(tags("series-uid-2", "sop-uid-2"));
        }
    }

    private JSONObject tags(String seriesUid, String sopUid)
    {
        return json("{\"StudyInstanceUID\":\"study-uid\",\"SeriesInstanceUID\":\"" + seriesUid
                + "\",\"SOPInstanceUID\":\"" + sopUid + "\",\"PatientName\":\"Object\",\"Modality\":\"DX\"}");
    }

    private JSONObject json(String value)
    {
        return JSONObject.parseObject(value);
    }

    private DcmUploadValidationResult validationPass()
    {
        DcmUploadValidationResult result = new DcmUploadValidationResult();
        result.setRecordId(1L);
        result.setFileName("test.dcm");
        result.setSopClassUid("1.2.3");
        result.setOfficialStatus("PASS");
        result.setCustomStatus("PASS");
        result.setFinalStatus("PASS");
        return result;
    }
}
