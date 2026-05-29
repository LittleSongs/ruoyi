package com.ruoyi.dcm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.dcm.service.IDcmUploadService;

@RestController
@RequestMapping("/dcm/upload")
public class DcmUploadController extends BaseController
{
    @Autowired
    private IDcmUploadService uploadService;

    @PreAuthorize("@ss.hasPermi('dcm:upload:add')")
    @Log(title = "DCM上传", businessType = BusinessType.IMPORT)
    @PostMapping
    public AjaxResult upload(@RequestParam("file") MultipartFile file)
    {
        return success(uploadService.uploadAndSync(file, getUserId(), getUsername()));
    }
}
