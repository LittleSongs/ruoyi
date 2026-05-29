package com.ruoyi.ndt.dicom.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.service.INdtDicomInstanceService;

@RestController
@RequestMapping("/ndt/dicom")
public class NdtDicomInstanceController extends BaseController
{
    @Autowired
    private INdtDicomInstanceService dicomInstanceService;

    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtDicomInstance instance)
    {
        startPage();
        List<NdtDicomInstance> list = dicomInstanceService.selectNdtDicomInstanceList(instance);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:list')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(dicomInstanceService.selectNdtDicomInstanceById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:upload')")
    @Log(title = "NDT DICOM上传", businessType = BusinessType.IMPORT)
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("taskId") Long taskId, @RequestParam("file") MultipartFile file)
    {
        return success(dicomInstanceService.uploadDicom(taskId, file, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:dicom:download')")
    @Log(title = "NDT DICOM下载", businessType = BusinessType.EXPORT)
    @GetMapping("/download/{id}")
    public void download(@PathVariable Long id, HttpServletResponse response) throws Exception
    {
        byte[] content = dicomInstanceService.downloadDicom(id);
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
        FileUtils.setAttachmentResponseHeader(response, "dicom-" + id + ".dcm");
        response.getOutputStream().write(content);
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:ohif')")
    @GetMapping("/{id}/ohif")
    public AjaxResult ohif(@PathVariable Long id)
    {
        return success(dicomInstanceService.getOhifViewerUrl(id));
    }
}
