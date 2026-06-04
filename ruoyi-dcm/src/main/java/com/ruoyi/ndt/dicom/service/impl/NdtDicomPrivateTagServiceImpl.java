package com.ruoyi.ndt.dicom.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomPrivateTag;
import com.ruoyi.ndt.dicom.mapper.NdtDicomPrivateTagMapper;
import com.ruoyi.ndt.dicom.service.INdtDicomPrivateTagService;

@Service
public class NdtDicomPrivateTagServiceImpl implements INdtDicomPrivateTagService
{
    @Autowired(required = false)
    private NdtDicomPrivateTagMapper privateTagMapper;

    public static List<NdtDicomPrivateTag> defaultPrivateTags()
    {
        return Arrays.asList(
                defaultTag("Manufacturer", "制造商", "0008,0070", "LO", ""),
                defaultTag("NdtClientName", "委托方", "0011,1010", "LO", ""),
                defaultTag("NdtInspectorName", "检测人员", "0011,1011", "LO", ""),
                defaultTag("NdtEvaluationConclusion", "评定结论", "0011,1012", "LT", ""));
    }

    @Override
    public List<NdtDicomPrivateTag> selectNdtDicomPrivateTagList(NdtDicomPrivateTag tag)
    {
        return privateTagMapper.selectNdtDicomPrivateTagList(tag);
    }

    @Override
    public List<NdtDicomPrivateTag> selectEnabledNdtDicomPrivateTagList()
    {
        List<NdtDicomPrivateTag> tags = privateTagMapper.selectEnabledNdtDicomPrivateTagList();
        return tags == null || tags.isEmpty() ? defaultPrivateTags() : tags;
    }

    @Override
    public List<String> selectEditableTagNames()
    {
        return selectEnabledNdtDicomPrivateTagList().stream()
                .filter(tag -> NdtConstants.YES.equals(tag.getEnabled()))
                .map(NdtDicomPrivateTag::getTagName)
                .filter(StringUtils::isNotEmpty)
                .collect(Collectors.toList());
    }

    @Override
    public NdtDicomPrivateTag selectEnabledTagByNameOrCode(String tagKey)
    {
        if (StringUtils.isEmpty(tagKey))
        {
            return null;
        }
        return selectEnabledNdtDicomPrivateTagList().stream()
                .filter(tag -> NdtConstants.YES.equals(tag.getEnabled()))
                .filter(tag -> tagKey.equals(tag.getTagName()) || (StringUtils.isNotEmpty(tag.getTagCode()) && tagKey.equals(tag.getTagCode())))
                .findFirst()
                .orElse(null);
    }

    @Override
    public NdtDicomPrivateTag selectNdtDicomPrivateTagById(Long id)
    {
        return privateTagMapper.selectNdtDicomPrivateTagById(id);
    }

    @Override
    public int insertNdtDicomPrivateTag(NdtDicomPrivateTag tag, String username)
    {
        normalize(tag);
        if (privateTagMapper.selectNdtDicomPrivateTagByName(tag.getTagName()) != null)
        {
            throw new ServiceException("DICOM标签名称已存在");
        }
        tag.setCreateBy(username);
        tag.setUpdateBy(username);
        return privateTagMapper.insertNdtDicomPrivateTag(tag);
    }

    @Override
    public int updateNdtDicomPrivateTag(NdtDicomPrivateTag tag, String username)
    {
        if (tag.getId() == null)
        {
            throw new ServiceException("DICOM标签配置ID不能为空");
        }
        normalize(tag);
        NdtDicomPrivateTag existing = privateTagMapper.selectNdtDicomPrivateTagByName(tag.getTagName());
        if (existing != null && !tag.getId().equals(existing.getId()))
        {
            throw new ServiceException("DICOM标签名称已存在");
        }
        tag.setUpdateBy(username);
        return privateTagMapper.updateNdtDicomPrivateTag(tag);
    }

    @Override
    public int deleteNdtDicomPrivateTagByIds(Long[] ids)
    {
        return privateTagMapper.softDeleteNdtDicomPrivateTagByIds(ids);
    }

    @Override
    public void checkEditableTagName(String tagName)
    {
        if (selectEnabledTagByNameOrCode(tagName) == null)
        {
            throw new ServiceException("不允许编辑未配置或未启用的DICOM标签：" + tagName);
        }
    }

    public List<NdtDicomPrivateTag> selectMissingConfigurableTags(List<String> existingTagNames)
    {
        List<String> existing = existingTagNames == null ? new ArrayList<>() : existingTagNames;
        return selectEnabledNdtDicomPrivateTagList().stream()
                .filter(tag -> !existing.contains(tag.getTagName()))
                .collect(Collectors.toList());
    }

    private void normalize(NdtDicomPrivateTag tag)
    {
        if (StringUtils.isEmpty(tag.getTagName()))
        {
            throw new ServiceException("DICOM标签名称不能为空");
        }
        if (StringUtils.isEmpty(tag.getTagLabel()))
        {
            throw new ServiceException("显示名称不能为空");
        }
        if (StringUtils.isEmpty(tag.getEnabled()))
        {
            tag.setEnabled(NdtConstants.YES);
        }
        if (StringUtils.isEmpty(tag.getBuiltin()))
        {
            tag.setBuiltin(NdtConstants.NO);
        }
        tag.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
    }

    private static NdtDicomPrivateTag defaultTag(String tagName, String tagLabel, String tagCode, String vr,
            String defaultValue)
    {
        NdtDicomPrivateTag tag = new NdtDicomPrivateTag();
        tag.setTagName(tagName);
        tag.setTagLabel(tagLabel);
        tag.setTagCode(tagCode);
        tag.setVr(vr);
        tag.setDefaultValue(defaultValue);
        tag.setEnabled(NdtConstants.YES);
        tag.setBuiltin(NdtConstants.YES);
        tag.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        return tag;
    }
}
