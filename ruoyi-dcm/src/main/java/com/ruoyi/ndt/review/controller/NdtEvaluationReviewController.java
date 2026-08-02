package com.ruoyi.ndt.review.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.review.dto.NdtEvaluationReviewCreateDto;
import com.ruoyi.ndt.review.service.INdtEvaluationReviewService;

@RestController @RequestMapping("/ndt/evaluation/review")
public class NdtEvaluationReviewController extends BaseController
{
    private final INdtEvaluationReviewService service;
    public NdtEvaluationReviewController(INdtEvaluationReviewService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:review:list')") @GetMapping
    public AjaxResult list(@RequestParam Long evaluationId){return success(service.selectByEvaluationId(evaluationId));}
    @PreAuthorize("@ss.hasPermi('ndt:review:add')") @Log(title="NDT评定复核",businessType=BusinessType.INSERT)
    @PostMapping public AjaxResult add(@RequestBody NdtEvaluationReviewCreateDto dto){return toAjax(service.insert(dto,getUserId(),getUsername()));}
}
