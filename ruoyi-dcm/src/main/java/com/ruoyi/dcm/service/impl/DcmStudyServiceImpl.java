package com.ruoyi.dcm.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.dcm.config.DcmProperties;
import com.ruoyi.dcm.domain.DcmStudy;
import com.ruoyi.dcm.mapper.DcmEvaluationMapper;
import com.ruoyi.dcm.mapper.DcmInstanceMapper;
import com.ruoyi.dcm.mapper.DcmSeriesMapper;
import com.ruoyi.dcm.mapper.DcmStudyMapper;
import com.ruoyi.dcm.service.IDcmStudyService;

@Service
public class DcmStudyServiceImpl implements IDcmStudyService
{
    @Autowired
    private DcmStudyMapper studyMapper;

    @Autowired
    private DcmSeriesMapper seriesMapper;

    @Autowired
    private DcmInstanceMapper instanceMapper;

    @Autowired
    private DcmEvaluationMapper evaluationMapper;

    @Autowired
    private DcmProperties properties;

    @Override
    public List<DcmStudy> selectDcmStudyList(DcmStudy study)
    {
        List<DcmStudy> list = studyMapper.selectDcmStudyList(study);
        list.forEach(this::fillViewerUrl);
        return list;
    }

    @Override
    public DcmStudy selectDcmStudyById(Long id)
    {
        DcmStudy study = studyMapper.selectDcmStudyById(id);
        if (study == null)
        {
            throw new ServiceException("Study 不存在或已删除");
        }
        fillViewerUrl(study);
        return study;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteDcmStudyByIds(Long[] ids)
    {
        evaluationMapper.softDeleteDcmEvaluationByStudyIds(ids);
        instanceMapper.softDeleteDcmInstanceByStudyIds(ids);
        seriesMapper.softDeleteDcmSeriesByStudyIds(ids);
        return studyMapper.softDeleteDcmStudyByIds(ids);
    }

    private void fillViewerUrl(DcmStudy study)
    {
        study.setOhifViewerUrl(properties.buildViewerUrl(study.getStudyInstanceUid()));
    }
}
