package com.ruoyi.dcm.mapper;

import com.ruoyi.dcm.domain.DcmValidationRecord;

public interface DcmValidationRecordMapper
{
    int insertDcmValidationRecord(DcmValidationRecord record);

    int updateDcmValidationRecordOrthancInstanceId(DcmValidationRecord record);
}
