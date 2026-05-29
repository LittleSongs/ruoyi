package com.ruoyi.dcm.mapper;

import java.util.List;
import com.ruoyi.dcm.domain.DcmSeries;

public interface DcmSeriesMapper
{
    List<DcmSeries> selectDcmSeriesList(DcmSeries series);

    DcmSeries selectDcmSeriesByUid(String seriesInstanceUid);

    int insertDcmSeries(DcmSeries series);

    int updateDcmSeries(DcmSeries series);

    int softDeleteDcmSeriesByStudyId(Long studyId);

    int softDeleteDcmSeriesByStudyIds(Long[] studyIds);
}
