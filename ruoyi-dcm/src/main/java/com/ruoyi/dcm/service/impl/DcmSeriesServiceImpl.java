package com.ruoyi.dcm.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.dcm.domain.DcmSeries;
import com.ruoyi.dcm.mapper.DcmSeriesMapper;
import com.ruoyi.dcm.service.IDcmSeriesService;

@Service
public class DcmSeriesServiceImpl implements IDcmSeriesService
{
    @Autowired
    private DcmSeriesMapper seriesMapper;

    @Override
    public List<DcmSeries> selectDcmSeriesList(DcmSeries series)
    {
        return seriesMapper.selectDcmSeriesList(series);
    }
}
