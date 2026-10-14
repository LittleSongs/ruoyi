package com.ruoyi.ndt.customer.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.ndt.customer.domain.NdtCustomerAccount;

public interface NdtCustomerAccountMapper
{
    List<NdtCustomerAccount> selectList(@Param("customerId") Long customerId);
    Long selectBindingCustomerId(@Param("userId") Long userId);
    Long selectActiveCustomerId(@Param("userId") Long userId);
    boolean hasCustomerRole(@Param("userId") Long userId);
    int insert(@Param("userId") Long userId, @Param("customerId") Long customerId,
            @Param("createBy") String createBy);
}
