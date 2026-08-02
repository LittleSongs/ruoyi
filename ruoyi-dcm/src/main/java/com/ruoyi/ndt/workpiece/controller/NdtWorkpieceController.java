package com.ruoyi.ndt.workpiece.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.dto.NdtWorkpieceSaveDto;
import com.ruoyi.ndt.workpiece.service.INdtWorkpieceService;

@RestController @RequestMapping("/ndt/workpiece")
public class NdtWorkpieceController extends BaseController
{
    private final INdtWorkpieceService service;
    public NdtWorkpieceController(INdtWorkpieceService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:workpiece:list')") @GetMapping("/list")
    public TableDataInfo list(NdtWorkpiece query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:workpiece:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:workpiece:add')") @Log(title="NDT工件",businessType=BusinessType.INSERT) @PostMapping public AjaxResult add(@RequestBody NdtWorkpieceSaveDto dto){return toAjax(service.insert(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:workpiece:edit')") @Log(title="NDT工件",businessType=BusinessType.UPDATE) @PutMapping public AjaxResult edit(@RequestBody NdtWorkpieceSaveDto dto){return toAjax(service.update(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:workpiece:remove')") @Log(title="NDT工件",businessType=BusinessType.DELETE) @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids){return toAjax(service.deleteByIds(ids));}
}
