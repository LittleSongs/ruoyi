package com.ruoyi.ndt.uid.controller;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.uid.domain.NdtUidRule;
import com.ruoyi.ndt.uid.service.INdtUidRuleService;

@RestController
@RequestMapping("/ndt/uidRule")
public class NdtUidRuleController extends BaseController
{
    @Autowired
    private INdtUidRuleService uidRuleService;

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtUidRule rule)
    {
        startPage();
        List<NdtUidRule> list = uidRuleService.selectNdtUidRuleList(rule);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(uidRuleService.selectNdtUidRuleById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:add')")
    @Log(title = "NDT UID规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtUidRule rule)
    {
        rule.setCreateBy(getUsername());
        rule.setUpdateBy(getUsername());
        return toAjax(uidRuleService.insertNdtUidRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:edit')")
    @Log(title = "NDT UID规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtUidRule rule)
    {
        rule.setUpdateBy(getUsername());
        return toAjax(uidRuleService.updateNdtUidRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:remove')")
    @Log(title = "NDT UID规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(uidRuleService.deleteNdtUidRuleByIds(ids));
    }

    @PreAuthorize("@ss.hasPermi('ndt:uidRule:generate')")
    @GetMapping("/generate")
    public AjaxResult generate(@RequestParam String uidType, @RequestParam(required = false) Long ruleId)
    {
        return AjaxResult.success("操作成功", uidRuleService.generateUid(uidType, ruleId));
    }
}
