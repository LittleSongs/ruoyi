package com.ruoyi.ndt.customer.service;

import java.util.List;
import com.ruoyi.ndt.customer.domain.NdtCustomer;

public interface INdtCustomerService
{
    List<NdtCustomer> selectList(NdtCustomer query);
    NdtCustomer selectById(Long id);
    int insert(NdtCustomer customer, String username);
    int update(NdtCustomer customer, String username);
    int deleteByIds(Long[] ids);
}
