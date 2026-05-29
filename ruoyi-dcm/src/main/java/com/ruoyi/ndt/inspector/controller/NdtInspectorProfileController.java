package com.ruoyi.ndt.inspector.controller;

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
import com.ruoyi.ndt.inspector.domain.NdtInspectorProfile;
import com.ruoyi.ndt.inspector.service.INdtInspectorProfileService;

@RestController
@RequestMapping("/ndt/inspector")
public class NdtInspectorProfileController extends BaseController
{
    @Autowired
    private INdtInspectorProfileService inspectorProfileService;

    @PreAuthorize("@ss.hasPermi('ndt:inspector:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtInspectorProfile profile)
    {
        startPage();
        List<NdtInspectorProfile> list = inspectorProfileService.selectNdtInspectorProfileList(profile);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:inspector:list')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(inspectorProfileService.selectNdtInspectorProfileById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:inspector:list')")
    @GetMapping("/user/{userId}")
    public AjaxResult getByUser(@PathVariable Long userId)
    {
        return success(inspectorProfileService.selectNdtInspectorProfileByUserId(userId));
    }

    @PreAuthorize("@ss.hasPermi('ndt:inspector:add')")
    @Log(title = "NDT检测人员档案", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtInspectorProfile profile)
    {
        return toAjax(inspectorProfileService.saveNdtInspectorProfile(profile, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:inspector:edit')")
    @Log(title = "NDT检测人员档案", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtInspectorProfile profile)
    {
        return toAjax(inspectorProfileService.saveNdtInspectorProfile(profile, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:inspector:remove')")
    @Log(title = "NDT检测人员档案", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(inspectorProfileService.deleteNdtInspectorProfileByIds(ids));
    }
}
