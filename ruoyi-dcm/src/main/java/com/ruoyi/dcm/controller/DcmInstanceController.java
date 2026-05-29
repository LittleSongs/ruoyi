package com.ruoyi.dcm.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.dcm.domain.DcmInstance;
import com.ruoyi.dcm.service.IDcmInstanceService;

@RestController
@RequestMapping("/dcm/instance")
public class DcmInstanceController extends BaseController
{
    @Autowired
    private IDcmInstanceService instanceService;

    @PreAuthorize("@ss.hasPermi('dcm:instance:list')")
    @GetMapping("/list")
    public TableDataInfo list(DcmInstance instance)
    {
        startPage();
        List<DcmInstance> list = instanceService.selectDcmInstanceList(instance);
        return getDataTable(list);
    }
}
