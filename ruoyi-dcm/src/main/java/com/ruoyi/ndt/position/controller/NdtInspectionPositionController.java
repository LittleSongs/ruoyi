package com.ruoyi.ndt.position.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.dto.NdtInspectionPositionSaveDto;
import com.ruoyi.ndt.position.service.INdtInspectionPositionService;

@RestController @RequestMapping("/ndt/position")
public class NdtInspectionPositionController extends BaseController
{
    private final INdtInspectionPositionService service;
    public NdtInspectionPositionController(INdtInspectionPositionService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:position:list')") @GetMapping("/list")
    public TableDataInfo list(NdtInspectionPosition query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:position:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:position:add')") @Log(title="NDT检测部位",businessType=BusinessType.INSERT) @PostMapping public AjaxResult add(@RequestBody NdtInspectionPositionSaveDto dto){return toAjax(service.insert(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:position:edit')") @Log(title="NDT检测部位",businessType=BusinessType.UPDATE) @PutMapping public AjaxResult edit(@RequestBody NdtInspectionPositionSaveDto dto){return toAjax(service.update(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:position:remove')") @Log(title="NDT检测部位",businessType=BusinessType.DELETE) @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids){return toAjax(service.deleteByIds(ids));}
}
