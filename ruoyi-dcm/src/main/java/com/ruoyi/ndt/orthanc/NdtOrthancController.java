package com.ruoyi.ndt.orthanc;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.dicom.domain.NdtDicomTagItem;

@RestController
@RequestMapping("/ndt/orthanc")
public class NdtOrthancController extends BaseController
{
    @Autowired
    private NdtOrthancService orthancService;

    @PreAuthorize("@ss.hasPermi('ndt:orthanc:list')")
    @GetMapping("/hierarchy")
    public AjaxResult hierarchy(String taskNo, String workpieceName)
    {
        return success(orthancService.selectHierarchy(taskNo, workpieceName));
    }

    @PreAuthorize("@ss.hasPermi('ndt:orthanc:query')")
    @GetMapping("/{dicomInstanceId}/tags")
    public AjaxResult tags(@PathVariable Long dicomInstanceId)
    {
        return success(orthancService.selectTagsByInstanceId(dicomInstanceId));
    }

    @PreAuthorize("@ss.hasPermi('ndt:orthanc:edit')")
    @Log(title = "Orthanc±êÇ©ÐÞ¸Ä", businessType = BusinessType.UPDATE)
    @PutMapping("/{dicomInstanceId}/tags")
    public AjaxResult updateTags(@PathVariable Long dicomInstanceId, @RequestBody List<NdtDicomTagItem> items)
    {
        return success(orthancService.updateTags(dicomInstanceId, items));
    }
}
