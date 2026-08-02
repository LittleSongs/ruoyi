package com.ruoyi.ndt.dicom.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;

public interface NdtDicomObjectMapper
{
    List<NdtDicomObject> selectList(NdtDicomObject query);
    List<NdtDicomObject> selectByPositionId(Long positionId);
    List<NdtDicomObject> selectByStudyAndPosition(@Param("studyId") Long studyId,
            @Param("positionId") Long positionId);
    NdtDicomObject selectById(Long id);
    NdtDicomObject selectBySopInstanceUid(String sopInstanceUid);
    NdtDicomObject selectOriginalBySeriesId(Long seriesId);
    NdtDicomObject selectOriginalByStudyAndPosition(@Param("studyId") Long studyId,
            @Param("positionId") Long positionId);
    int insert(NdtDicomObject object);
    int update(NdtDicomObject object);
    int softDeleteByIds(Long[] ids);
}
