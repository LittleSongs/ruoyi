package com.ruoyi.ndt.customer.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.customer.domain.NdtCustomer;
import com.ruoyi.ndt.customer.dto.NdtCustomerSaveDto;
import com.ruoyi.ndt.customer.service.INdtCustomerService;

@RestController
@RequestMapping("/ndt/customer")
public class NdtCustomerController extends BaseController
{
    private final INdtCustomerService service;
    public NdtCustomerController(INdtCustomerService service) { this.service = service; }
    @PreAuthorize("@ss.hasPermi('ndt:customer:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtCustomer query) { startPage(); List<NdtCustomer> rows=service.selectList(query); return getDataTable(rows); }
    @PreAuthorize("@ss.hasPermi('ndt:customer:query')")
    @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id) { return success(service.selectById(id)); }
    @PreAuthorize("@ss.hasPermi('ndt:customer:add')")
    @Log(title="NDT客户",businessType=BusinessType.INSERT)
    @PostMapping public AjaxResult add(@RequestBody NdtCustomerSaveDto dto) { return toAjax(service.insert(dto,getUsername())); }
    @PreAuthorize("@ss.hasPermi('ndt:customer:edit')")
    @Log(title="NDT客户",businessType=BusinessType.UPDATE)
    @PutMapping public AjaxResult edit(@RequestBody NdtCustomerSaveDto dto) { return toAjax(service.update(dto,getUsername())); }
    @PreAuthorize("@ss.hasPermi('ndt:customer:remove')")
    @Log(title="NDT客户",businessType=BusinessType.DELETE)
    @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids) { return toAjax(service.deleteByIds(ids)); }
}
