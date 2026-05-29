package com.ruoyi.ndt.inspector.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.inspector.domain.NdtInspectorProfile;
import com.ruoyi.ndt.inspector.mapper.NdtInspectorProfileMapper;
import com.ruoyi.ndt.inspector.service.INdtInspectorProfileService;

@Service
public class NdtInspectorProfileServiceImpl implements INdtInspectorProfileService
{
    @Autowired
    private NdtInspectorProfileMapper inspectorProfileMapper;

    @Override
    public List<NdtInspectorProfile> selectNdtInspectorProfileList(NdtInspectorProfile profile)
    {
        return inspectorProfileMapper.selectNdtInspectorProfileList(profile);
    }

    @Override
    public NdtInspectorProfile selectNdtInspectorProfileById(Long id)
    {
        return inspectorProfileMapper.selectNdtInspectorProfileById(id);
    }

    @Override
    public NdtInspectorProfile selectNdtInspectorProfileByUserId(Long userId)
    {
        return inspectorProfileMapper.selectNdtInspectorProfileByUserId(userId);
    }

    @Override
    public int saveNdtInspectorProfile(NdtInspectorProfile profile, String username)
    {
        if (profile.getUserId() == null)
        {
            throw new ServiceException("用户ID不能为空");
        }
        if (StringUtils.isEmpty(profile.getInspectorNo()))
        {
            throw new ServiceException("检测人员编号不能为空");
        }
        profile.setUpdateBy(username);
        profile.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        NdtInspectorProfile existing = inspectorProfileMapper.selectNdtInspectorProfileByUserId(profile.getUserId());
        if (profile.getId() == null && existing != null)
        {
            profile.setId(existing.getId());
        }
        if (profile.getId() == null)
        {
            profile.setCreateBy(username);
            return inspectorProfileMapper.insertNdtInspectorProfile(profile);
        }
        return inspectorProfileMapper.updateNdtInspectorProfile(profile);
    }

    @Override
    public int deleteNdtInspectorProfileByIds(Long[] ids)
    {
        return inspectorProfileMapper.softDeleteNdtInspectorProfileByIds(ids);
    }
}
