package com.ruoyi.web.controller.ndt;

import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.NdtCustomerAccountSaveDto;
import com.ruoyi.ndt.NdtCustomerAccountService;

@RestController
@RequestMapping("/ndt/customer/{customerId}/accounts")
public class NdtCustomerAccountController extends BaseController
{
    private final NdtCustomerAccountService service;
    public NdtCustomerAccountController(NdtCustomerAccountService service) { this.service=service; }

    @PreAuthorize("@ss.hasPermi('ndt:customer:account:list')")
    @GetMapping
    public TableDataInfo listAccounts(@PathVariable Long customerId)
    {
        startPage();
        return getDataTable(service.list(customerId));
    }

    @PreAuthorize("@ss.hasPermi('ndt:customer:account:add')")
    @Log(title="客户公司账号", businessType=BusinessType.INSERT)
    @PostMapping
    public AjaxResult addAccount(@PathVariable Long customerId, @Valid @RequestBody NdtCustomerAccountSaveDto dto)
    {
        return toAjax(service.create(customerId, dto));
    }

    @PreAuthorize("@ss.hasPermi('ndt:customer:account:edit')")
    @Log(title="客户公司账号", businessType=BusinessType.UPDATE)
    @PutMapping("/{userId}")
    public AjaxResult editAccount(@PathVariable Long customerId, @PathVariable Long userId,
            @Valid @RequestBody NdtCustomerAccountSaveDto dto)
    {
        return toAjax(service.update(customerId, userId, dto));
    }

    @PreAuthorize("@ss.hasPermi('ndt:customer:account:remove')")
    @Log(title="客户公司账号", businessType=BusinessType.DELETE)
    @DeleteMapping("/{userId}")
    public AjaxResult removeAccount(@PathVariable Long customerId, @PathVariable Long userId)
    {
        return toAjax(service.delete(customerId, userId));
    }

    public static class PasswordBody { public String password; }
    @PreAuthorize("@ss.hasPermi('ndt:customer:account:resetPwd')")
    @Log(title="客户公司账号", businessType=BusinessType.UPDATE)
    @PutMapping("/{userId}/password")
    public AjaxResult resetPassword(@PathVariable Long customerId, @PathVariable Long userId,
            @RequestBody PasswordBody body)
    {
        return toAjax(service.resetPassword(customerId, userId, body.password));
    }
}
