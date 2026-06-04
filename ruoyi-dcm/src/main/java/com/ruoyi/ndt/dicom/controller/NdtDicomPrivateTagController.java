package com.ruoyi.ndt.dicom.controller;

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
import com.ruoyi.ndt.dicom.domain.NdtDicomPrivateTag;
import com.ruoyi.ndt.dicom.service.INdtDicomPrivateTagService;

@RestController
@RequestMapping("/ndt/dicomPrivateTag")
public class NdtDicomPrivateTagController extends BaseController
{
    @Autowired
    private INdtDicomPrivateTagService privateTagService;

    @PreAuthorize("@ss.hasAnyPermi('ndt:dicomPrivateTag:list,ndt:dicom:tag:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtDicomPrivateTag tag)
    {
        startPage();
        List<NdtDicomPrivateTag> list = privateTagService.selectNdtDicomPrivateTagList(tag);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasAnyPermi('ndt:dicomPrivateTag:list,ndt:dicom:tag:list')")
    @GetMapping("/enabled")
    public AjaxResult enabled()
    {
        return success(privateTagService.selectEnabledNdtDicomPrivateTagList());
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicomPrivateTag:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(privateTagService.selectNdtDicomPrivateTagById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicomPrivateTag:add')")
    @Log(title = "NDT DICOM私有标签", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtDicomPrivateTag tag)
    {
        return toAjax(privateTagService.insertNdtDicomPrivateTag(tag, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicomPrivateTag:edit')")
    @Log(title = "NDT DICOM私有标签", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtDicomPrivateTag tag)
    {
        return toAjax(privateTagService.updateNdtDicomPrivateTag(tag, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicomPrivateTag:remove')")
    @Log(title = "NDT DICOM私有标签", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(privateTagService.deleteNdtDicomPrivateTagByIds(ids));
    }
}
