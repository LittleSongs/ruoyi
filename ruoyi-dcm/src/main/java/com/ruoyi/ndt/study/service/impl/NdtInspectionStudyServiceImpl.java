package com.ruoyi.ndt.study.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.study.domain.NdtInspectionStudy;
import com.ruoyi.ndt.study.mapper.NdtInspectionStudyMapper;
import com.ruoyi.ndt.study.service.INdtInspectionStudyService;

@Service
public class NdtInspectionStudyServiceImpl implements INdtInspectionStudyService
{
    private final NdtInspectionStudyMapper mapper;
    private final NdtAccessService access;
    private final NdtProperties properties;

    public NdtInspectionStudyServiceImpl(NdtInspectionStudyMapper mapper,
            NdtAccessService access, NdtProperties properties)
    {
        this.mapper = mapper;
        this.access = access;
        this.properties = properties;
    }

    public List<NdtInspectionStudy> selectList(NdtInspectionStudy query)
    {
        access.applyTaskListScope(query);
        return mapper.selectList(query);
    }

    public NdtInspectionStudy selectById(Long id)
    {
        NdtInspectionStudy study = require(id);
        access.checkViewTask(study.getTaskId());
        return study;
    }

    public String getOhifViewerUrl(Long id)
    {
        NdtInspectionStudy study = selectById(id);
        return properties.buildViewerUrl(study.getStudyInstanceUid(), study.getTaskId(), study.getId(),
                access.canEvaluateTask(study.getTaskId()));
    }

    private NdtInspectionStudy require(Long id)
    {
        NdtInspectionStudy study = mapper.selectById(id);
        if (study == null) throw new ServiceException("检测Study不存在");
        return study;
    }
}
