package com.ruoyi.ndt.orthanc;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;

@RestController @RequestMapping("/ndt/orthanc")
public class NdtOrthancController extends BaseController
{
    private final NdtOrthancService service;
    public NdtOrthancController(NdtOrthancService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:orthanc:list')") @GetMapping("/hierarchy")
    public AjaxResult hierarchy(@RequestParam Long taskId){return success(service.selectHierarchy(taskId));}
    @PreAuthorize("@ss.hasPermi('ndt:orthanc:query')") @GetMapping("/{objectId}/tags")
    public AjaxResult tags(@PathVariable Long objectId){return success(service.selectTagsByObjectId(objectId));}
}
