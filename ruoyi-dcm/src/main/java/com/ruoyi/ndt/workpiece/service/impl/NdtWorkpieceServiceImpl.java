package com.ruoyi.ndt.workpiece.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.mapper.NdtWorkpieceMapper;
import com.ruoyi.ndt.workpiece.service.INdtWorkpieceService;

@Service
public class NdtWorkpieceServiceImpl implements INdtWorkpieceService
{
    private final NdtWorkpieceMapper mapper;
    private final NdtAccessService access;
    public NdtWorkpieceServiceImpl(NdtWorkpieceMapper mapper, NdtAccessService access)
    {
        this.mapper = mapper; this.access = access;
    }
    public List<NdtWorkpiece> selectList(NdtWorkpiece query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }
    public NdtWorkpiece selectById(Long id)
    {
        NdtWorkpiece value = require(id); access.checkViewTask(value.getTaskId()); return value;
    }
    public int insert(NdtWorkpiece value, String username)
    {
        validate(value); access.checkManageTask(value.getTaskId());
        if (value.getSortNo() == null) value.setSortNo(0);
        if (StringUtils.isEmpty(value.getStatus())) value.setStatus(NdtConstants.WORKPIECE_STATUS_PENDING);
        value.setCreateBy(username); value.setUpdateBy(username); return mapper.insert(value);
    }
    public int update(NdtWorkpiece value, String username)
    {
        NdtWorkpiece old = require(value.getId()); access.checkManageTask(old.getTaskId());
        value.setTaskId(old.getTaskId()); validate(value); value.setUpdateBy(username); return mapper.update(value);
    }
    public int deleteByIds(Long[] ids)
    {
        for (Long id : ids) access.checkManageTask(require(id).getTaskId());
        return mapper.softDeleteByIds(ids);
    }
    private NdtWorkpiece require(Long id)
    {
        NdtWorkpiece value = mapper.selectById(id);
        if (value == null) throw new ServiceException("工件不存在"); return value;
    }
    private void validate(NdtWorkpiece value)
    {
        if (value.getTaskId() == null) throw new ServiceException("任务不能为空");
        if (StringUtils.isEmpty(value.getWorkpieceName())) throw new ServiceException("工件名称不能为空");
    }
}
