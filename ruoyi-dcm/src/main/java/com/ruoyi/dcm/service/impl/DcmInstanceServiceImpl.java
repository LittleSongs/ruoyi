package com.ruoyi.dcm.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.dcm.domain.DcmInstance;
import com.ruoyi.dcm.mapper.DcmInstanceMapper;
import com.ruoyi.dcm.service.IDcmInstanceService;

@Service
public class DcmInstanceServiceImpl implements IDcmInstanceService
{
    @Autowired
    private DcmInstanceMapper instanceMapper;

    @Override
    public List<DcmInstance> selectDcmInstanceList(DcmInstance instance)
    {
        return instanceMapper.selectDcmInstanceList(instance);
    }
}
