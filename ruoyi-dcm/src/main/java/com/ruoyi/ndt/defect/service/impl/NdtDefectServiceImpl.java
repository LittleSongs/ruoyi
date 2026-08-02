package com.ruoyi.ndt.defect.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.defect.domain.NdtDefect;
import com.ruoyi.ndt.defect.mapper.NdtDefectMapper;
import com.ruoyi.ndt.defect.service.INdtDefectService;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.security.NdtAccessService;

@Service
public class NdtDefectServiceImpl implements INdtDefectService
{
    private final NdtDefectMapper mapper;
    private final NdtDicomObjectMapper objectMapper;
    private final NdtAccessService access;
    public NdtDefectServiceImpl(NdtDefectMapper mapper, NdtDicomObjectMapper objectMapper, NdtAccessService access)
    {
        this.mapper = mapper; this.objectMapper = objectMapper; this.access = access;
    }
    public List<NdtDefect> selectList(NdtDefect query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }
    public NdtDefect selectById(Long id)
    {
        NdtDefect value = require(id); access.checkViewTask(value.getTaskId()); return value;
    }
    public int insert(NdtDefect value, String username)
    {
        validate(value);
        NdtDicomObject original = requireOriginal(value.getOriginalObjectId());
        access.checkEvaluateTask(original.getTaskId());
        value.setCreateBy(username); value.setUpdateBy(username); return mapper.insert(value);
    }
    public int update(NdtDefect value, String username)
    {
        NdtDefect old = require(value.getId()); access.checkEvaluateTask(old.getTaskId());
        value.setOriginalObjectId(old.getOriginalObjectId()); validate(value);
        value.setUpdateBy(username); return mapper.update(value);
    }
    public int deleteByIds(Long[] ids)
    {
        for (Long id : ids) access.checkEvaluateTask(require(id).getTaskId());
        return mapper.softDeleteByIds(ids);
    }
    private NdtDefect require(Long id)
    {
        NdtDefect value = mapper.selectById(id);
        if (value == null) throw new ServiceException("缺陷不存在"); return value;
    }
    private NdtDicomObject requireOriginal(Long id)
    {
        NdtDicomObject object = objectMapper.selectById(id);
        if (object == null) throw new ServiceException("原始图对象不存在");
        if (!NdtConstants.OBJECT_TYPE_ORIGINAL_IMAGE.equals(object.getObjectType()))
            throw new ServiceException("缺陷只能关联ORIGINAL_IMAGE对象");
        return object;
    }
    private void validate(NdtDefect value)
    {
        if (value.getOriginalObjectId() == null) throw new ServiceException("原始图对象不能为空");
        if (StringUtils.isEmpty(value.getDefectNo())) throw new ServiceException("缺陷编号不能为空");
    }
}
