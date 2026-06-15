package com.ruoyi.ndt.dicom;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;
import com.ruoyi.dcm.validation.DcmUploadValidationResult;
import com.ruoyi.dcm.validation.DcmUploadValidationService;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.dicom.service.impl.NdtDicomInstanceServiceImpl;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;

class NdtDicomInstanceServiceImplValidationTest
{
    @Mock
    private NdtDicomInstanceMapper dicomInstanceMapper;
    @Mock
    private NdtInspectionTaskMapper taskMapper;
    @Mock
    private OrthancService orthancService;
    @Mock
    private INdtIntegrityService integrityService;
    @Mock
    private NdtAccessService accessService;
    @Mock
    private DcmUploadValidationService validationService;

    private NdtDicomInstanceServiceImpl service;

    @BeforeEach
    void setUp()
    {
        MockitoAnnotations.openMocks(this);
        service = new NdtDicomInstanceServiceImpl();
        ReflectionTestUtils.setField(service, "dicomInstanceMapper", dicomInstanceMapper);
        ReflectionTestUtils.setField(service, "taskMapper", taskMapper);
        ReflectionTestUtils.setField(service, "orthancService", orthancService);
        ReflectionTestUtils.setField(service, "integrityService", integrityService);
        ReflectionTestUtils.setField(service, "accessService", accessService);
        ReflectionTestUtils.setField(service, "properties", new NdtProperties());
        ReflectionTestUtils.setField(service, "validationService", validationService);
    }

    @Test
    void validationFailureReturnsResultAndDoesNotUploadToOrthanc()
    {
        NdtInspectionTask task = new NdtInspectionTask();
        task.setId(8L);
        when(taskMapper.selectNdtInspectionTaskById(8L)).thenReturn(task);
        when(integrityService.calculateSha256(any())).thenReturn("sha256");
        DcmUploadValidationResult validation = new DcmUploadValidationResult();
        validation.setRecordId(12L);
        validation.setFileName("bad.dcm");
        validation.setSopClassUid("1.2.3");
        validation.setStudyInstanceUid("study");
        validation.setSeriesInstanceUid("series");
        validation.setSopInstanceUid("sop");
        validation.setOfficialStatus("PASS");
        validation.setCustomStatus("FAIL");
        validation.setFinalStatus("FAIL");
        validation.setErrors(List.of("缺少必备Tag：(0011,1010) NDTClientName"));
        when(validationService.validate(any(), any(), any())).thenReturn(validation);

        MockMultipartFile file = new MockMultipartFile("file", "bad.dcm", "application/dicom", new byte[] { 1, 2, 3 });
        NdtDicomUploadResult result = service.uploadDicom(8L, file, 1L, "admin");

        assertEquals("FAIL", result.getFinalStatus());
        assertEquals(12L, result.getValidationRecordId());
        assertEquals(1, result.getErrors().size());
        verify(orthancService, never()).uploadInstance(any(byte[].class));
    }
}
