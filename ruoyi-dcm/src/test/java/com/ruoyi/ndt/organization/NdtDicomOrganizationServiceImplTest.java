package com.ruoyi.ndt.organization;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.organization.domain.NdtInspectionPart;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeResponse;
import com.ruoyi.ndt.organization.domain.NdtObjectTreeRow;
import com.ruoyi.ndt.organization.domain.NdtPartDicomObject;
import com.ruoyi.ndt.organization.mapper.NdtDicomOrganizationMapper;
import com.ruoyi.ndt.organization.service.impl.NdtDicomOrganizationServiceImpl;

class NdtDicomOrganizationServiceImplTest
{
    @Mock
    private NdtDicomOrganizationMapper organizationMapper;

    @Mock
    private NdtDicomInstanceMapper instanceMapper;

    private NdtDicomOrganizationServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new NdtDicomOrganizationServiceImpl(organizationMapper, instanceMapper);
    }

    @Test
    void registerOriginalCreatesOnePartAnchoredToTheOriginalSop()
    {
        NdtDicomInstance instance = instance(31L, 8L, "study-1", "series-1", "source-1");
        when(instanceMapper.selectNdtDicomInstanceById(31L)).thenReturn(instance);
        when(organizationMapper.selectSeriesIdByUid("series-1")).thenReturn(41L);
        when(organizationMapper.selectPartBySourceSop(8L, "source-1")).thenReturn(null);
        when(organizationMapper.insertInspectionPart(any())).thenAnswer(invocation -> {
            ((NdtInspectionPart) invocation.getArgument(0)).setId(51L);
            return 1;
        });

        service.registerOriginal(8L, 31L);

        ArgumentCaptor<NdtInspectionPart> partCaptor = ArgumentCaptor.forClass(NdtInspectionPart.class);
        ArgumentCaptor<NdtPartDicomObject> membershipCaptor =
                ArgumentCaptor.forClass(NdtPartDicomObject.class);
        verify(organizationMapper).insertInspectionPart(partCaptor.capture());
        verify(organizationMapper).insertPartObject(membershipCaptor.capture());
        assertEquals("P-000031", partCaptor.getValue().getPartNo());
        assertEquals("source-1", partCaptor.getValue().getSourceSopInstanceUid());
        assertEquals(51L, membershipCaptor.getValue().getPartId());
        assertEquals(NdtConstants.OBJECT_TYPE_ORIGINAL, membershipCaptor.getValue().getObjectRole());
        assertEquals(NdtConstants.OBJECT_TYPE_ORIGINAL, instance.getObjectType());
        assertEquals(41L, instance.getDicomSeriesId());
    }

    @Test
    void registerRelatedAttachesOneSrToEveryDistinctSourcePart()
    {
        NdtDicomInstance sr = instance(61L, 8L, "study-1", "sr-series", "sr-1");
        sr.setModality("SR");
        when(instanceMapper.selectNdtDicomInstanceById(61L)).thenReturn(sr);
        when(organizationMapper.selectSeriesIdByUid("sr-series")).thenReturn(71L);
        NdtInspectionPart first = part(81L, 8L, "source-1");
        NdtInspectionPart second = part(82L, 8L, "source-2");
        when(organizationMapper.selectPartBySourceSop(8L, "source-1")).thenReturn(first);
        when(organizationMapper.selectPartBySourceSop(8L, "source-2")).thenReturn(second);

        service.registerRelated(8L, 61L,
                Arrays.asList("source-1", "source-2", "source-1"), NdtConstants.OBJECT_TYPE_SR);

        ArgumentCaptor<NdtPartDicomObject> membershipCaptor =
                ArgumentCaptor.forClass(NdtPartDicomObject.class);
        verify(organizationMapper, org.mockito.Mockito.times(2)).insertPartObject(membershipCaptor.capture());
        assertEquals(List.of(81L, 82L), membershipCaptor.getAllValues().stream()
                .map(NdtPartDicomObject::getPartId).toList());
        assertEquals(NdtConstants.OBJECT_TYPE_SR, sr.getObjectType());
        assertEquals(71L, sr.getDicomSeriesId());
    }

    @Test
    void registerRelatedCanResolveAPartThroughADerivedSourceObject()
    {
        NdtDicomInstance sr = instance(61L, 8L, "study-1", "sr-series", "sr-1");
        when(instanceMapper.selectNdtDicomInstanceById(61L)).thenReturn(sr);
        when(organizationMapper.selectSeriesIdByUid("sr-series")).thenReturn(71L);
        when(organizationMapper.selectPartBySourceSop(8L, "processed-1")).thenReturn(null);
        when(organizationMapper.selectPartsByObjectSop(8L, "processed-1"))
                .thenReturn(List.of(part(81L, 8L, "source-1")));

        service.registerRelated(8L, 61L, List.of("processed-1"), NdtConstants.OBJECT_TYPE_SR);

        ArgumentCaptor<NdtPartDicomObject> membershipCaptor =
                ArgumentCaptor.forClass(NdtPartDicomObject.class);
        verify(organizationMapper).insertPartObject(membershipCaptor.capture());
        assertEquals(81L, membershipCaptor.getValue().getPartId());
    }

    @Test
    void selectObjectTreeGroupsByPartAndSortsObjectsByRoleThenInstance()
    {
        when(organizationMapper.selectObjectTreeRows(8L)).thenReturn(List.of(
                row(51L, "P-000031", 3L, NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE, "processed-2", "2"),
                row(51L, "P-000031", 1L, NdtConstants.OBJECT_TYPE_ORIGINAL, "source-1", "1"),
                row(51L, "P-000031", 2L, NdtConstants.OBJECT_TYPE_PROCESSED_IMAGE, "processed-1", "1")));
        when(organizationMapper.selectUnassignedObjectRows(8L)).thenReturn(List.of(
                row(null, null, 9L, NdtConstants.OBJECT_TYPE_OTHER_DERIVED, "orphan-1", "1")));

        NdtObjectTreeResponse response = service.selectObjectTree(8L);

        assertEquals(1, response.getParts().size());
        assertEquals(List.of("source-1", "processed-1", "processed-2"),
                response.getParts().get(0).getObjects().stream()
                        .map(item -> item.getSopInstanceUid()).toList());
        assertEquals("orphan-1", response.getUnassignedObjects().get(0).getSopInstanceUid());
        assertNotNull(response.getParts().get(0).getObjects().get(0).getLabel());
    }

    private NdtDicomInstance instance(Long id, Long taskId, String studyUid, String seriesUid, String sopUid)
    {
        NdtDicomInstance value = new NdtDicomInstance();
        value.setId(id);
        value.setTaskId(taskId);
        value.setStudyInstanceUid(studyUid);
        value.setSeriesInstanceUid(seriesUid);
        value.setSopInstanceUid(sopUid);
        value.setModality("CR");
        value.setSeriesNumber("1");
        value.setInstanceNumber("1");
        value.setSeriesDescription("NDT source");
        return value;
    }

    private NdtInspectionPart part(Long id, Long taskId, String sourceSopUid)
    {
        NdtInspectionPart value = new NdtInspectionPart();
        value.setId(id);
        value.setTaskId(taskId);
        value.setSourceSopInstanceUid(sourceSopUid);
        return value;
    }

    private NdtObjectTreeRow row(Long partId, String partNo, Long instanceId, String objectType,
            String sopUid, String instanceNumber)
    {
        NdtObjectTreeRow value = new NdtObjectTreeRow();
        value.setPartId(partId);
        value.setPartNo(partNo);
        value.setPartName(partNo);
        value.setSourceDicomInstanceId(31L);
        value.setSourceSopInstanceUid("source-1");
        value.setDicomInstanceId(instanceId);
        value.setObjectType(objectType);
        value.setStudyInstanceUid("study-1");
        value.setSeriesInstanceUid("series-1");
        value.setSopInstanceUid(sopUid);
        value.setModality("CR");
        value.setSeriesNumber("1");
        value.setInstanceNumber(instanceNumber);
        value.setSeriesDescription("NDT object");
        return value;
    }
}
