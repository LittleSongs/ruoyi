package com.ruoyi.dcm.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.dcm.domain.DcmSeries;
import com.ruoyi.dcm.service.IDcmSeriesService;

@RestController
@RequestMapping("/dcm/series")
public class DcmSeriesController extends BaseController
{
    @Autowired
    private IDcmSeriesService seriesService;

    @PreAuthorize("@ss.hasPermi('dcm:series:list')")
    @GetMapping("/list")
    public TableDataInfo list(DcmSeries series)
    {
        startPage();
        List<DcmSeries> list = seriesService.selectDcmSeriesList(series);
        return getDataTable(list);
    }
}
