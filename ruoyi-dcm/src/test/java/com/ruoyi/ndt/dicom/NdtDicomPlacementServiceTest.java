package com.ruoyi.ndt.dicom;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.dcm.validation.DcmUploadValidationResult;
import com.ruoyi.dcm.validation.DcmUploadValidationService;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.dicom.service.impl.NdtDicomObjectServiceImpl;
import com.ruoyi.ndt.integrity.mapper.NdtDicomIntegrityRecordMapper;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.mapper.NdtInspectionPositionMapper;
import com.ruoyi.ndt.relation.domain.NdtDicomObjectRelation;
import com.ruoyi.ndt.relation.mapper.NdtDicomObjectRelationMapper;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.series.domain.NdtDicomSeries;
import com.ruoyi.ndt.series.mapper.NdtDicomSeriesMapper;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;

class NdtDicomPlacementServiceTest
{
    private NdtDicomObjectMapper objectMapper;
    private NdtInspectionPositionMapper positionMapper;
    private NdtInspectionStudyMapper studyMapper;
    private NdtDicomSeriesMapper seriesMapper;
    private NdtDicomObjectRelationMapper relationMapper;
    private INdtIntegrityService integrityService;
    private OrthancService orthanc;
    private DcmUploadValidationService validationService;
    private NdtDicomObjectServiceImpl service;

    @BeforeEach
    void setUp()
    {
        objectMapper = mock(NdtDicomObjectMapper.class);
        positionMapper = mock(NdtInspectionPositionMapper.class);
        studyMapper = mock(NdtInspectionStudyMapper.class);
        seriesMapper = mock(NdtDicomSeriesMapper.class);
        relationMapper = mock(NdtDicomObjectRelationMapper.class);
        integrityService = mock(INdtIntegrityService.class);
        orthanc = mock(OrthancService.class);
        validationService = mock(DcmUploadValidationService.class);
        service = new NdtDicomObjectServiceImpl(objectMapper, positionMapper, studyMapper, seriesMapper,
                relationMapper, mock(NdtDicomIntegrityRecordMapper.class), integrityService, orthanc,
                validationService, mock(NdtAccessService.class));
    }

    @Test
    void rejectsASecondOriginalImageInTheSameSeries() throws Exception
    {
        MultipartFile file = file("original-2.dcm");
        DcmUploadValidationResult validation = new DcmUploadValidationResult();
        validation.setFinalStatus("PASS");
        validation.setSopInstanceUid("sop-2");
        when(validationService.validate(any(), any(), any())).thenReturn(validation);
        when(integrityService.calculateSha256(any())).thenReturn("sha");
        when(positionMapper.selectByIdForUpdate(30L)).thenReturn(position());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(seriesMapper.selectBySeriesInstanceUid("series-1")).thenReturn(series());
        when(objectMapper.selectOriginalByStudyAndPosition(40L, 30L)).thenReturn(source());
        uploadResponse("orthanc-original-2", "study-1", "series-1", "sop-2");

        assertThrows(ServiceException.class,
                () -> service.uploadOriginal(30L, file, 1L, "tester"));

        verify(objectMapper, never()).insert(any());
        verify(orthanc).deleteInstance("orthanc-original-2");
    }

    @Test
    void rejectsASecondImageSeriesForTheSameStudyAndPosition() throws Exception
    {
        MultipartFile file = file("other-series-original.dcm");
        DcmUploadValidationResult validation = new DcmUploadValidationResult();
        validation.setFinalStatus("PASS");
        validation.setSopInstanceUid("sop-other-series");
        when(validationService.validate(any(), any(), any())).thenReturn(validation);
        when(integrityService.calculateSha256(any())).thenReturn("sha");
        when(positionMapper.selectByIdForUpdate(30L)).thenReturn(position());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(objectMapper.selectOriginalByStudyAndPosition(40L, 30L)).thenReturn(source());
        uploadResponse("orthanc-other-series", "study-1", "series-2", "sop-other-series");

        assertThrows(ServiceException.class,
                () -> service.uploadOriginal(30L, file, 1L, "tester"));

        verify(seriesMapper, never()).insert(any());
        verify(objectMapper, never()).insert(any());
        verify(orthanc).deleteInstance("orthanc-other-series");
    }

    @Test
    void rejectsAnImageDerivedDicomFromAnotherSeries() throws Exception
    {
        when(objectMapper.selectById(10L)).thenReturn(source());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(positionMapper.selectById(30L)).thenReturn(position());
        uploadResponse("orthanc-derived", "study-1", "series-2", "sop-2");

        assertThrows(ServiceException.class, () -> service.uploadDerivedImageDicom(10L,
                NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE, file("processed.dcm"), 1L, "tester"));

        verify(objectMapper, never()).insert(any());
        verify(orthanc).deleteInstance("orthanc-derived");
    }

    @Test
    void rejectsAnSrThatReusesTheImageSeries() throws Exception
    {
        when(objectMapper.selectById(10L)).thenReturn(source());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(positionMapper.selectById(30L)).thenReturn(position());
        uploadResponse("orthanc-sr", "study-1", "series-1", "sop-sr");

        assertThrows(ServiceException.class, () -> service.uploadDerivedDicom(10L,
                NdtConstants.OBJECT_TYPE_SR, NdtConstants.RELATION_TYPE_GENERATED_FROM,
                file("report-sr.dcm"), 1L, "tester"));

        verify(objectMapper, never()).insert(any());
        verify(orthanc).deleteInstance("orthanc-sr");
    }

    @Test
    void storesAnImageDerivedDicomInTheSourceSeries() throws Exception
    {
        when(objectMapper.selectById(10L)).thenReturn(source());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(positionMapper.selectById(30L)).thenReturn(position());
        when(seriesMapper.selectBySeriesInstanceUid("series-1")).thenReturn(series());
        doAnswer(invocation -> {
            ((NdtDicomObject) invocation.getArgument(0)).setId(11L);
            return 1;
        }).when(objectMapper).insert(any());
        uploadResponse("orthanc-derived", "study-1", "series-1", "sop-derived");

        service.uploadDerivedImageDicom(10L, NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE,
                file("processed.dcm"), 1L, "tester");

        ArgumentCaptor<NdtDicomObject> objectCaptor = ArgumentCaptor.forClass(NdtDicomObject.class);
        verify(objectMapper).insert(objectCaptor.capture());
        assertEquals(20L, objectCaptor.getValue().getSeriesId());
        ArgumentCaptor<NdtDicomObjectRelation> relationCaptor =
                ArgumentCaptor.forClass(NdtDicomObjectRelation.class);
        verify(relationMapper).insert(relationCaptor.capture());
        assertEquals(NdtConstants.RELATION_TYPE_DERIVED_FROM,
                relationCaptor.getValue().getRelationType());
    }

    @Test
    void storesAnSrInANewSeriesAndLinksItToTheSource() throws Exception
    {
        when(objectMapper.selectById(10L)).thenReturn(source());
        when(studyMapper.selectByStudyInstanceUid("study-1")).thenReturn(study());
        when(positionMapper.selectById(30L)).thenReturn(position());
        doAnswer(invocation -> {
            ((NdtDicomSeries) invocation.getArgument(0)).setId(21L);
            return 1;
        }).when(seriesMapper).insert(any());
        doAnswer(invocation -> {
            ((NdtDicomObject) invocation.getArgument(0)).setId(12L);
            return 1;
        }).when(objectMapper).insert(any());
        uploadResponse("orthanc-sr", "study-1", "series-sr", "sop-sr");

        service.uploadDerivedDicom(10L, NdtConstants.OBJECT_TYPE_SR,
                NdtConstants.RELATION_TYPE_GENERATED_FROM, file("report-sr.dcm"), 1L, "tester");

        ArgumentCaptor<NdtDicomObject> objectCaptor = ArgumentCaptor.forClass(NdtDicomObject.class);
        verify(objectMapper).insert(objectCaptor.capture());
        assertEquals(21L, objectCaptor.getValue().getSeriesId());
        ArgumentCaptor<NdtDicomObjectRelation> relationCaptor =
                ArgumentCaptor.forClass(NdtDicomObjectRelation.class);
        verify(relationMapper).insert(relationCaptor.capture());
        assertEquals(NdtConstants.RELATION_TYPE_GENERATED_FROM,
                relationCaptor.getValue().getRelationType());
    }

    private MultipartFile file(String name) throws Exception
    {
        MultipartFile file = mock(MultipartFile.class);
        when(file.isEmpty()).thenReturn(false);
        when(file.getBytes()).thenReturn(new byte[] { 1, 2, 3 });
        when(file.getOriginalFilename()).thenReturn(name);
        return file;
    }

    private void uploadResponse(String orthancId, String studyUid, String seriesUid, String sopUid)
    {
        JSONObject response = new JSONObject();
        response.put("ID", orthancId);
        response.put("ParentStudy", "orthanc-study");
        response.put("ParentSeries", "orthanc-series");
        JSONObject tags = new JSONObject();
        tags.put("StudyInstanceUID", studyUid);
        tags.put("SeriesInstanceUID", seriesUid);
        tags.put("SOPInstanceUID", sopUid);
        tags.put("SOPClassUID", "sop-class");
        when(orthanc.uploadInstance(any())).thenReturn(response);
        when(orthanc.getInstanceSimplifiedTags(orthancId)).thenReturn(tags);
    }

    private NdtDicomObject source()
    {
        NdtDicomObject source = new NdtDicomObject();
        source.setId(10L);
        source.setSeriesId(20L);
        source.setStudyId(40L);
        source.setPositionId(30L);
        source.setWorkpieceId(50L);
        source.setTaskId(60L);
        source.setObjectType(NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE);
        source.setStudyUid("study-1");
        source.setSeriesUid("series-1");
        return source;
    }

    private NdtInspectionPosition position()
    {
        NdtInspectionPosition position = new NdtInspectionPosition();
        position.setId(30L);
        position.setWorkpieceId(50L);
        position.setTaskId(60L);
        return position;
    }

    private NdtInspectionStudy study()
    {
        NdtInspectionStudy study = new NdtInspectionStudy();
        study.setId(40L);
        study.setWorkpieceId(50L);
        study.setStudyInstanceUid("study-1");
        return study;
    }

    private NdtDicomSeries series()
    {
        NdtDicomSeries series = new NdtDicomSeries();
        series.setId(20L);
        series.setStudyId(40L);
        series.setWorkpieceId(50L);
        series.setPositionId(30L);
        series.setSeriesInstanceUid("series-1");
        return series;
    }
}
