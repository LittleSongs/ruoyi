package com.ruoyi.ndt.integrity.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;

@RestController
@RequestMapping("/ndt/integrity")
public class NdtIntegrityController extends BaseController
{
    @Autowired
    private INdtIntegrityService integrityService;

    @PreAuthorize("@ss.hasPermi('ndt:integrity:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtDicomIntegrityRecord record)
    {
        startPage();
        List<NdtDicomIntegrityRecord> list = integrityService.selectNdtDicomIntegrityRecordList(record);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:integrity:list')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(integrityService.selectNdtDicomIntegrityRecordById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:integrity:verify')")
    @Log(title = "NDT DICOM完整性重检", businessType = BusinessType.UPDATE)
    @PostMapping("/verify/{dicomInstanceId}")
    public AjaxResult verify(@PathVariable Long dicomInstanceId)
    {
        return success(integrityService.verifyByDicomInstanceId(dicomInstanceId));
    }
}
