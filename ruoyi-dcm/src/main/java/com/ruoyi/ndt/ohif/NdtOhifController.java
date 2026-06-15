package com.ruoyi.ndt.ohif;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.ndt.config.NdtProperties;

/**
 * OHIF integration config controller.
 */
@RestController
@RequestMapping("/ndt/ohif")
public class NdtOhifController extends BaseController
{
    @Autowired
    private NdtProperties ndtProperties;

    @PreAuthorize("@ss.hasPermi('ndt:ohif:list')")
    @GetMapping("/config")
    public AjaxResult config()
    {
        NdtProperties.Ohif ohif = ndtProperties.getOhif();
        return AjaxResult.success("查询成功", ohif);
    }
}
