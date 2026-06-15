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
import com.ruoyi.dcm.domain.DcmValidationRule;
import com.ruoyi.dcm.service.IDcmValidationRuleService;

@RestController
@RequestMapping("/dcm/validationRule")
public class DcmValidationRuleController extends BaseController
{
    @Autowired
    private IDcmValidationRuleService ruleService;

    @PreAuthorize("@ss.hasAnyPermi('dcm:validationRule:list,ndt:validationRule:list')")
    @GetMapping("/list")
    public TableDataInfo list(DcmValidationRule rule)
    {
        startPage();
        List<DcmValidationRule> list = ruleService.selectDcmValidationRuleList(rule);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('dcm:validationRule:query,ndt:validationRule:query')")
    @GetMapping("/{ruleId}")
    public AjaxResult getInfo(@PathVariable Long ruleId)
    {
        return success(ruleService.selectDcmValidationRuleById(ruleId));
    }

    @PreAuthorize("@ss.hasAnyPermi('dcm:validationRule:add,ndt:validationRule:add')")
    @Log(title = "DICOM自定义校验规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DcmValidationRule rule)
    {
        return toAjax(ruleService.insertDcmValidationRule(rule, getUsername()));
    }

    @PreAuthorize("@ss.hasAnyPermi('dcm:validationRule:edit,ndt:validationRule:edit')")
    @Log(title = "DICOM自定义校验规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DcmValidationRule rule)
    {
        return toAjax(ruleService.updateDcmValidationRule(rule, getUsername()));
    }

    @PreAuthorize("@ss.hasAnyPermi('dcm:validationRule:remove,ndt:validationRule:remove')")
    @Log(title = "DICOM自定义校验规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds)
    {
        return toAjax(ruleService.deleteDcmValidationRuleByIds(ruleIds));
    }
}
