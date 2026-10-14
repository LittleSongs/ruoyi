package com.ruoyi.ndt.customer.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/** Customer login account; company ownership is immutable. Never exposes credentials. */
public class NdtCustomerAccount extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long userId;
    private Long customerId;
    private String userName;
    private String nickName;
    private String phonenumber;
    private String email;
    private String status;

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }
    public String getPhonenumber() { return phonenumber; }
    public void setPhonenumber(String phonenumber) { this.phonenumber = phonenumber; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
