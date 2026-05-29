package com.ruoyi.dcm.controller;

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
import com.ruoyi.dcm.domain.DcmEvaluation;
import com.ruoyi.dcm.service.IDcmEvaluationService;

@RestController
@RequestMapping("/dcm/evaluation")
public class DcmEvaluationController extends BaseController
{
    @Autowired
    private IDcmEvaluationService evaluationService;

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:list')")
    @GetMapping("/list")
    public TableDataInfo list(DcmEvaluation evaluation)
    {
        startPage();
        List<DcmEvaluation> list = evaluationService.selectDcmEvaluationList(evaluation);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(evaluationService.selectDcmEvaluationById(id));
    }

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:query')")
    @GetMapping("/byStudy/{studyId}")
    public AjaxResult byStudy(@PathVariable Long studyId)
    {
        return success(evaluationService.selectDcmEvaluationByStudyId(studyId));
    }

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:add')")
    @Log(title = "DCM评定", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DcmEvaluation evaluation)
    {
        return toAjax(evaluationService.saveDcmEvaluation(evaluation, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:edit')")
    @Log(title = "DCM评定", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DcmEvaluation evaluation)
    {
        return toAjax(evaluationService.saveDcmEvaluation(evaluation, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('dcm:evaluation:remove')")
    @Log(title = "DCM评定", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(evaluationService.deleteDcmEvaluationByIds(ids, getUsername()));
    }
}
