package com.ruoyi.ndt.dicom.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;

public interface INdtDicomInstanceService
{
    List<NdtDicomInstance> selectNdtDicomInstanceList(NdtDicomInstance instance);

    NdtDicomInstance selectNdtDicomInstanceById(Long id);

    NdtDicomUploadResult uploadDicom(Long taskId, MultipartFile file, Long userId, String username);

    byte[] downloadDicom(Long id);

    String getOhifViewerUrl(Long id);

    String buildOhifViewerUrl(String studyInstanceUid, Long taskId);
}
