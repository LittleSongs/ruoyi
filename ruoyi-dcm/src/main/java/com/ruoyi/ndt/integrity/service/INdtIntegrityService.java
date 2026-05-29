package com.ruoyi.ndt.integrity.service;

import java.util.List;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;

public interface INdtIntegrityService
{
    List<NdtDicomIntegrityRecord> selectNdtDicomIntegrityRecordList(NdtDicomIntegrityRecord record);

    NdtDicomIntegrityRecord selectNdtDicomIntegrityRecordById(Long id);

    String calculateSha256(byte[] content);

    NdtDicomIntegrityRecord verifyByDicomInstanceId(Long dicomInstanceId);

    String signContent(String content);

    boolean verifySignature(String content, String signature);
}
