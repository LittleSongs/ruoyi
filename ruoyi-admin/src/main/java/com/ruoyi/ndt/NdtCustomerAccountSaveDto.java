package com.ruoyi.ndt;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/** Deliberately has no customerId/deptId/roleIds: the server supplies ownership and role. */
public class NdtCustomerAccountSaveDto
{
    @NotBlank @Size(min=2, max=20)
    public String userName;
    @NotBlank @Size(max=30)
    public String nickName;
    @Email @Size(max=50)
    public String email;
    @Pattern(regexp="^$|^1[3-9]\\d{9}$")
    public String phonenumber;
    @Pattern(regexp="[01]") @NotBlank
    public String status = "0";
    @Size(max=500)
    public String remark;
    @Size(min=5, max=20)
    public String password;
}
