package com.ruoyi.ndt.defect.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.defect.domain.NdtDefect;
import com.ruoyi.ndt.defect.dto.NdtDefectSaveDto;
import com.ruoyi.ndt.defect.service.INdtDefectService;

@RestController @RequestMapping("/ndt/defect")
public class NdtDefectController extends BaseController
{
    private final INdtDefectService service;
    public NdtDefectController(INdtDefectService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:defect:list')") @GetMapping("/list") public TableDataInfo list(NdtDefect query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:defect:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:defect:add')") @Log(title="NDT缺陷",businessType=BusinessType.INSERT) @PostMapping public AjaxResult add(@RequestBody NdtDefectSaveDto dto){service.insert(dto,getUsername());return success(dto);}
    @PreAuthorize("@ss.hasPermi('ndt:defect:edit')") @Log(title="NDT缺陷",businessType=BusinessType.UPDATE) @PutMapping public AjaxResult edit(@RequestBody NdtDefectSaveDto dto){return toAjax(service.update(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:defect:remove')") @Log(title="NDT缺陷",businessType=BusinessType.DELETE) @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids){return toAjax(service.deleteByIds(ids));}
}
