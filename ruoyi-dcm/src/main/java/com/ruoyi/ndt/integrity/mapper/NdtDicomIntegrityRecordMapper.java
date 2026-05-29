package com.ruoyi.ndt.integrity.mapper;

import java.util.List;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;

public interface NdtDicomIntegrityRecordMapper
{
    List<NdtDicomIntegrityRecord> selectNdtDicomIntegrityRecordList(NdtDicomIntegrityRecord record);

    NdtDicomIntegrityRecord selectNdtDicomIntegrityRecordById(Long id);

    NdtDicomIntegrityRecord selectNdtDicomIntegrityRecordBySopUid(String sopInstanceUid);

    int insertNdtDicomIntegrityRecord(NdtDicomIntegrityRecord record);

    int updateNdtDicomIntegrityRecord(NdtDicomIntegrityRecord record);
}
