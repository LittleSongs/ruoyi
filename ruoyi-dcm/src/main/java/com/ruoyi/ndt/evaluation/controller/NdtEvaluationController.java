package com.ruoyi.ndt.evaluation.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;

@RestController
@RequestMapping("/ndt/evaluation")
public class NdtEvaluationController extends BaseController
{
    @Autowired
    private INdtEvaluationService evaluationService;

    @PreAuthorize("@ss.hasPermi('ndt:evaluation:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtEvaluation evaluation)
    {
        startPage();
        List<NdtEvaluation> list = evaluationService.selectNdtEvaluationList(evaluation);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:evaluation:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(evaluationService.selectNdtEvaluationById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:evaluation:add')")
    @Log(title = "NDT评定结果", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtEvaluation evaluation)
    {
        return toAjax(evaluationService.saveNdtEvaluation(evaluation, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:evaluation:edit')")
    @Log(title = "NDT评定结果", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtEvaluation evaluation)
    {
        return toAjax(evaluationService.saveNdtEvaluation(evaluation, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:evaluation:remove')")
    @Log(title = "NDT评定结果", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(evaluationService.deleteNdtEvaluationByIds(ids));
    }
}
