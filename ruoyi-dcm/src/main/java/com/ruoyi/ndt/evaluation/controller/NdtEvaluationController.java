package com.ruoyi.ndt.evaluation.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;
import com.ruoyi.ndt.evaluation.service.INdtEvaluationService;

@RestController
@RequestMapping("/ndt/evaluation")
@Anonymous
public class NdtEvaluationController extends BaseController
{
    @Autowired
    private INdtEvaluationService evaluationService;

    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(NdtEvaluation evaluation)
    {
        startPage();
        List<NdtEvaluation> list = evaluationService.selectNdtEvaluationList(evaluation);
        return getDataTable(list);
    }

    @Anonymous
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(evaluationService.selectNdtEvaluationById(id));
    }

    @Anonymous
    @Log(title = "NDT评定结果", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtEvaluation evaluation)
    {
        return toAjax(evaluationService.saveNdtEvaluation(evaluation, null, "anonymous"));
    }

    @Anonymous
    @Log(title = "NDT评定结果", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtEvaluation evaluation)
    {
        return toAjax(evaluationService.saveNdtEvaluation(evaluation, null, "anonymous"));
    }

    @Anonymous
    @Log(title = "NDT评定结果", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(evaluationService.deleteNdtEvaluationByIds(ids));
    }
}
