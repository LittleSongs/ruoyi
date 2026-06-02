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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.domain.NdtDicomTagItem;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;
import com.ruoyi.ndt.dicom.service.INdtDicomInstanceService;
import com.ruoyi.ndt.orthanc.NdtOrthancService;

@RestController
@RequestMapping("/ndt/dicom")
public class NdtDicomInstanceController extends BaseController
{
    @Autowired
    private INdtDicomInstanceService dicomInstanceService;

    @Autowired
    private NdtOrthancService orthancService;

    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtDicomInstance instance)
    {
        startPage();
        List<NdtDicomInstance> list = dicomInstanceService.selectNdtDicomInstanceList(instance);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(dicomInstanceService.selectNdtDicomInstanceById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')")
    @Log(title = "NDT DICOM文件", businessType = BusinessType.INSERT)
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("taskId") Long taskId, @RequestParam("file") MultipartFile file)
    {
        NdtDicomUploadResult result = dicomInstanceService.uploadDicom(taskId, file, getUserId(), getUsername());
        return success(result);
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:download')")
    @Log(title = "NDT DICOM文件", businessType = BusinessType.OTHER)
    @GetMapping("/download/{id}")
    public AjaxResult download(@PathVariable Long id)
    {
        byte[] bytes = dicomInstanceService.downloadDicom(id);
        return success(bytes);
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:tag:list')")
    @GetMapping("/{id}/tags")
    public AjaxResult tags(@PathVariable Long id)
    {
        return success(orthancService.selectTagsByInstanceId(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:tag:edit')")
    @Log(title = "NDT DICOM标签", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/tags")
    public AjaxResult updateTags(@PathVariable Long id, @RequestBody List<NdtDicomTagItem> items)
    {
        return success(orthancService.updateTags(id, items));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:tag:add')")
    @Log(title = "NDT DICOM标签", businessType = BusinessType.INSERT)
    @PostMapping("/{id}/tags")
    public AjaxResult addTag(@PathVariable Long id, @RequestBody List<NdtDicomTagItem> items)
    {
        return success(orthancService.updateTags(id, items));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:tag:remove')")
    @Log(title = "NDT DICOM标签", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}/tags")
    public AjaxResult removeTag(@PathVariable Long id, @RequestBody List<NdtDicomTagItem> items)
    {
        return success(orthancService.updateTags(id, items));
    }
}
