package com.ruoyi.ndt.customer.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtCustomer extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private String name;
    private String contactName;
    private String contactPhone;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
