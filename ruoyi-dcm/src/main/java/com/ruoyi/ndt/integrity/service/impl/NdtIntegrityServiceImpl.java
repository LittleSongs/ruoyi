package com.ruoyi.ndt.integrity.service.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomInstance;
import com.ruoyi.ndt.dicom.mapper.NdtDicomInstanceMapper;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;
import com.ruoyi.ndt.integrity.mapper.NdtDicomIntegrityRecordMapper;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.security.NdtAccessService;

@Service
public class NdtIntegrityServiceImpl implements INdtIntegrityService
{
    @Autowired(required = false)
    private NdtDicomIntegrityRecordMapper integrityRecordMapper;

    @Autowired(required = false)
    private NdtDicomInstanceMapper dicomInstanceMapper;

    @Autowired(required = false)
    private OrthancService orthancService;

    @Autowired(required = false)
    private NdtAccessService accessService;

    @Override
    public List<NdtDicomIntegrityRecord> selectNdtDicomIntegrityRecordList(NdtDicomIntegrityRecord record)
    {
        if (accessService != null)
        {
            accessService.applyTaskListScope(record);
        }
        return integrityRecordMapper.selectNdtDicomIntegrityRecordList(record);
    }

    @Override
    public NdtDicomIntegrityRecord selectNdtDicomIntegrityRecordById(Long id)
    {
        return integrityRecordMapper.selectNdtDicomIntegrityRecordById(id);
    }

    @Override
    public String calculateSha256(byte[] content)
    {
        try
        {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(content);
            StringBuilder value = new StringBuilder(hash.length * 2);
            for (byte item : hash)
            {
                value.append(String.format("%02x", item));
            }
            return value.toString();
        }
        catch (NoSuchAlgorithmException ex)
        {
            throw new ServiceException("当前JDK不支持SHA-256算法");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public NdtDicomIntegrityRecord verifyByDicomInstanceId(Long dicomInstanceId)
    {
        NdtDicomInstance instance = dicomInstanceMapper.selectNdtDicomInstanceById(dicomInstanceId);
        if (instance == null)
        {
            throw new ServiceException("DICOM实例不存在");
        }
        if (accessService != null && !accessService.canViewTask(instance.getTaskId()))
        {
            throw new ServiceException("无权访问该检测任务");
        }
        NdtDicomIntegrityRecord record = integrityRecordMapper
                .selectNdtDicomIntegrityRecordBySopUid(instance.getSopInstanceUid());
        if (record == null)
        {
            throw new ServiceException("完整性记录不存在");
        }
        String currentSha256 = calculateSha256(orthancService.downloadInstanceFile(instance.getOrthancInstanceId()));
        String status = currentSha256.equalsIgnoreCase(record.getFileSha256())
                ? NdtConstants.INTEGRITY_STATUS_PASS : NdtConstants.INTEGRITY_STATUS_FAIL;
        record.setVerifyStatus(status);
        record.setLastVerifyTime(new Date());
        integrityRecordMapper.updateNdtDicomIntegrityRecord(record);
        instance.setIntegrityStatus(status);
        dicomInstanceMapper.updateNdtDicomInstance(instance);
        return record;
    }

    @Override
    public String signContent(String content)
    {
        // TODO: Load the formal private key and sign with java.security in phase 2.
        return Base64.getEncoder().encodeToString(calculateSha256(content.getBytes()).getBytes());
    }

    @Override
    public boolean verifySignature(String content, String signature)
    {
        // TODO: Load the formal public key and verify with java.security in phase 2.
        return signContent(content).equals(signature);
    }
}
