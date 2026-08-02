package com.ruoyi.ndt.study.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.service.INdtInspectionStudyService;

@RestController
@RequestMapping("/ndt/study")
public class NdtInspectionStudyController extends BaseController
{
    private final INdtInspectionStudyService service;

    public NdtInspectionStudyController(INdtInspectionStudyService service) { this.service = service; }

    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/list")
    public TableDataInfo list(NdtInspectionStudy query)
    {
        startPage();
        return getDataTable(service.selectList(query));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{id}")
    public AjaxResult get(@PathVariable Long id) { return success(service.selectById(id)); }

    @PreAuthorize("@ss.hasPermi('ndt:task:ohif')")
    @GetMapping("/{id}/ohif")
    public AjaxResult ohif(@PathVariable Long id)
    {
        return AjaxResult.success("查询成功", service.getOhifViewerUrl(id));
    }
}
