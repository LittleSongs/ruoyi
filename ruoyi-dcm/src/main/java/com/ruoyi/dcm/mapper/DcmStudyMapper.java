package com.ruoyi.dcm.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.dcm.domain.DcmStudy;

public interface DcmStudyMapper
{
    List<DcmStudy> selectDcmStudyList(DcmStudy study);

    DcmStudy selectDcmStudyById(Long id);

    DcmStudy selectDcmStudyByUid(String studyInstanceUid);

    int insertDcmStudy(DcmStudy study);

    int updateDcmStudy(DcmStudy study);

    int updateDcmStudyStatus(@Param("id") Long id, @Param("status") String status, @Param("updateBy") String updateBy);

    int softDeleteDcmStudyByIds(Long[] ids);
}
