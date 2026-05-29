package com.ruoyi.dcm.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.service.IDcmStudyService;

@RestController
@RequestMapping("/dcm/study")
public class DcmStudyController extends BaseController
{
    @Autowired
    private IDcmStudyService studyService;

    @PreAuthorize("@ss.hasPermi('dcm:study:list')")
    @GetMapping("/list")
    public TableDataInfo list(DcmStudy study)
    {
        startPage();
        List<DcmStudy> list = studyService.selectDcmStudyList(study);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('dcm:study:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(studyService.selectDcmStudyById(id));
    }

    @PreAuthorize("@ss.hasPermi('dcm:study:remove')")
    @Log(title = "DCM Study", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(studyService.deleteDcmStudyByIds(ids));
    }
}
