package com.ruoyi.ndt.customer.mapper;

import java.util.List;
import com.ruoyi.ndt.customer.domain.NdtCustomer;

public interface NdtCustomerMapper
{
    List<NdtCustomer> selectList(NdtCustomer query);
    NdtCustomer selectById(Long id);
    int insert(NdtCustomer customer);
    int update(NdtCustomer customer);
    int softDeleteByIds(Long[] ids);
}
