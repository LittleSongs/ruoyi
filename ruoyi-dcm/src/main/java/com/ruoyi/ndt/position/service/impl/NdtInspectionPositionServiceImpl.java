package com.ruoyi.ndt.position.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.position.domain.NdtInspectionPosition;
import com.ruoyi.ndt.position.mapper.NdtInspectionPositionMapper;
import com.ruoyi.ndt.position.service.INdtInspectionPositionService;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.workpiece.domain.NdtWorkpiece;
import com.ruoyi.ndt.workpiece.mapper.NdtWorkpieceMapper;

@Service
public class NdtInspectionPositionServiceImpl implements INdtInspectionPositionService
{
    private final NdtInspectionPositionMapper mapper;
    private final NdtWorkpieceMapper workpieceMapper;
    private final NdtAccessService access;
    public NdtInspectionPositionServiceImpl(NdtInspectionPositionMapper mapper,
            NdtWorkpieceMapper workpieceMapper, NdtAccessService access)
    {
        this.mapper = mapper; this.workpieceMapper = workpieceMapper; this.access = access;
    }
    public List<NdtInspectionPosition> selectList(NdtInspectionPosition query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }
    public NdtInspectionPosition selectById(Long id)
    {
        NdtInspectionPosition value = require(id); access.checkViewTask(value.getTaskId()); return value;
    }
    public int insert(NdtInspectionPosition value, String username)
    {
        validate(value);
        NdtWorkpiece workpiece = requireWorkpiece(value.getWorkpieceId());
        access.checkManageTask(workpiece.getTaskId());
        if (value.getSortNo() == null) value.setSortNo(0);
        value.setCreateBy(username); value.setUpdateBy(username); return mapper.insert(value);
    }
    public int update(NdtInspectionPosition value, String username)
    {
        NdtInspectionPosition old = require(value.getId()); access.checkManageTask(old.getTaskId());
        value.setWorkpieceId(old.getWorkpieceId()); validate(value);
        value.setUpdateBy(username); return mapper.update(value);
    }
    public int deleteByIds(Long[] ids)
    {
        for (Long id : ids) access.checkManageTask(require(id).getTaskId());
        return mapper.softDeleteByIds(ids);
    }
    private NdtInspectionPosition require(Long id)
    {
        NdtInspectionPosition value = mapper.selectById(id);
        if (value == null) throw new ServiceException("检测部位不存在"); return value;
    }
    private NdtWorkpiece requireWorkpiece(Long id)
    {
        NdtWorkpiece value = workpieceMapper.selectById(id);
        if (value == null) throw new ServiceException("工件不存在"); return value;
    }
    private void validate(NdtInspectionPosition value)
    {
        if (value.getWorkpieceId() == null) throw new ServiceException("工件不能为空");
        if (StringUtils.isEmpty(value.getPositionName())) throw new ServiceException("部位名称不能为空");
        if (StringUtils.isEmpty(value.getPositionCode())) throw new ServiceException("部位编码不能为空");
    }
}
