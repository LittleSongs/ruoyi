package com.ruoyi.ndt.evaluation.controller;

import java.util.List;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
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
    @Log(title = "NDT评定SR批量提交", businessType = BusinessType.INSERT)
    @PostMapping("/batch-submit-sr")
    public AjaxResult batchSubmitSr(@RequestParam("taskId") Long taskId,
            @RequestParam("evaluationsJson") String evaluationsJson,
            @RequestParam("srFile") MultipartFile srFile)
    {
        return success(evaluationService.batchSubmitWithSr(taskId, parseEvaluations(evaluationsJson), srFile,
                "anonymous"));
    }

    @Anonymous
    @GetMapping("/by-sr")
    public AjaxResult listBySr(@RequestParam("taskId") Long taskId,
            @RequestParam("srSopInstanceUID") String srSopInstanceUid)
    {
        return success(evaluationService.selectNdtEvaluationListBySr(taskId, srSopInstanceUid));
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

    private List<NdtEvaluation> parseEvaluations(String evaluationsJson)
    {
        JSONArray array = JSON.parseArray(evaluationsJson);
        return array.stream().map(item -> toEvaluation((JSONObject) item)).toList();
    }

    private NdtEvaluation toEvaluation(JSONObject object)
    {
        NdtEvaluation evaluation = new NdtEvaluation();
        evaluation.setId(object.getLong("id"));
        evaluation.setTaskId(object.getLong("taskId"));
        evaluation.setStudyInstanceUid(first(object, "studyInstanceUID", "studyInstanceUid"));
        evaluation.setSeriesInstanceUid(first(object, "seriesInstanceUID", "seriesInstanceUid"));
        evaluation.setSopInstanceUid(first(object, "sopInstanceUID", "sopInstanceUid"));
        evaluation.setDefectType(object.getString("defectType"));
        evaluation.setDefectLevel(object.getString("defectLevel"));
        evaluation.setConclusion(object.getString("conclusion"));
        evaluation.setAnnotationJson(object.getString("annotationJson"));
        evaluation.setStatus(object.getString("status"));
        evaluation.setRemark(object.getString("remark"));
        return evaluation;
    }

    private String first(JSONObject object, String firstKey, String secondKey)
    {
        String value = object.getString(firstKey);
        return value == null ? object.getString(secondKey) : value;
    }
}
