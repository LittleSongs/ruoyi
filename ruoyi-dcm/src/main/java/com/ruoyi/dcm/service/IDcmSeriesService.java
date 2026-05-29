package com.ruoyi.dcm.service;

import java.util.List;
import com.ruoyi.dcm.domain.DcmSeries;

public interface IDcmSeriesService
{
    List<DcmSeries> selectDcmSeriesList(DcmSeries series);
}
