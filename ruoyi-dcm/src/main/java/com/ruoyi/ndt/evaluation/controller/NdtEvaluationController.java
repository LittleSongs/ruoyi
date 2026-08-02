package com.ruoyi.ndt.evaluation.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.dto.NdtEvaluationSaveDto;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;

@RestController @RequestMapping("/ndt/evaluation")
public class NdtEvaluationController extends BaseController
{
    private final INdtEvaluationService service;
    public NdtEvaluationController(INdtEvaluationService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:list')") @GetMapping("/list") public TableDataInfo list(NdtEvaluation query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:add')") @Log(title="NDT评定",businessType=BusinessType.INSERT) @PostMapping public AjaxResult add(@RequestBody NdtEvaluationSaveDto dto){service.insert(dto,getUserId(),getUsername());return success(dto);}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:edit')") @Log(title="NDT评定",businessType=BusinessType.UPDATE) @PutMapping public AjaxResult edit(@RequestBody NdtEvaluationSaveDto dto){return toAjax(service.update(dto,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:submit')") @PostMapping("/{id}/submit") public AjaxResult submit(@PathVariable Long id){return toAjax(service.submit(id,getUserId(),getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:submit')") @PostMapping("/{id}/submit-with-sr")
    public AjaxResult submitWithSr(@PathVariable Long id,@RequestParam Long sourceObjectId,@RequestParam MultipartFile srFile){return success(service.submitWithSr(id,sourceObjectId,srFile,getUserId(),getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:evaluation:remove')") @Log(title="NDT评定",businessType=BusinessType.DELETE) @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids){return toAjax(service.deleteByIds(ids));}
}
