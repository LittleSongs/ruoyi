package com.ruoyi.ndt.relation.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.ndt.dicom.service.INdtDicomObjectService;

@RestController @RequestMapping("/ndt/dicom/relation")
public class NdtDicomObjectRelationController extends BaseController
{
    private final INdtDicomObjectService objectService;
    public NdtDicomObjectRelationController(INdtDicomObjectService objectService){this.objectService=objectService;}
    @PreAuthorize("@ss.hasPermi('ndt:dicom:query')")
    @GetMapping("/object/{objectId}") public AjaxResult list(@PathVariable Long objectId){return success(objectService.relations(objectId));}
}
