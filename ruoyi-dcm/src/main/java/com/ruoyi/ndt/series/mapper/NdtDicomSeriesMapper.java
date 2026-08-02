package com.ruoyi.ndt.series.mapper;

import java.util.List;
import com.ruoyi.ndt.series.domain.NdtDicomSeries;

public interface NdtDicomSeriesMapper
{
    NdtDicomSeries selectById(Long id);
    List<NdtDicomSeries> selectByStudyId(Long studyId);
    NdtDicomSeries selectBySeriesInstanceUid(String seriesInstanceUid);
    int insert(NdtDicomSeries series);
}
