package com.ruoyi.ndt.customer.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.customer.domain.NdtCustomer;
import com.ruoyi.ndt.customer.mapper.NdtCustomerMapper;
import com.ruoyi.ndt.customer.service.INdtCustomerService;

@Service
public class NdtCustomerServiceImpl implements INdtCustomerService
{
    private final NdtCustomerMapper mapper;
    public NdtCustomerServiceImpl(NdtCustomerMapper mapper) { this.mapper = mapper; }
    public List<NdtCustomer> selectList(NdtCustomer query) { return mapper.selectList(query); }
    public NdtCustomer selectById(Long id) { return mapper.selectById(id); }
    public int insert(NdtCustomer customer, String username)
    {
        validate(customer);
        customer.setCreateBy(username);
        customer.setUpdateBy(username);
        return mapper.insert(customer);
    }
    public int update(NdtCustomer customer, String username)
    {
        if (customer.getId() == null) throw new ServiceException("客户ID不能为空");
        validate(customer);
        customer.setUpdateBy(username);
        return mapper.update(customer);
    }
    @Transactional
    public int deleteByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0) throw new ServiceException("请选择客户公司");
        for (Long id : ids)
        {
            if (mapper.selectByIdForUpdate(id) == null) throw new ServiceException("客户公司不存在");
            if (mapper.countReferences(id) > 0)
                throw new ServiceException("客户公司下仍有账号或检测任务，不能删除");
        }
        return mapper.softDeleteByIds(ids);
    }
    private void validate(NdtCustomer customer)
    {
        if (StringUtils.isEmpty(customer.getName())) throw new ServiceException("客户名称不能为空");
    }
}
