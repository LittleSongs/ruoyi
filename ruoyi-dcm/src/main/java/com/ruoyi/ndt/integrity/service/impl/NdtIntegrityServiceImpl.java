package com.ruoyi.ndt.integrity.service.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.dicom.domain.NdtDicomObject;
import com.ruoyi.ndt.dicom.mapper.NdtDicomObjectMapper;
import com.ruoyi.ndt.integrity.domain.NdtDicomIntegrityRecord;
import com.ruoyi.ndt.integrity.mapper.NdtDicomIntegrityRecordMapper;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.orthanc.OrthancService;
import com.ruoyi.ndt.security.NdtAccessService;

@Service
public class NdtIntegrityServiceImpl implements INdtIntegrityService
{
    private final NdtDicomIntegrityRecordMapper mapper;
    private final NdtDicomObjectMapper objectMapper;
    private final OrthancService orthanc;
    private final NdtAccessService access;
    public NdtIntegrityServiceImpl(NdtDicomIntegrityRecordMapper mapper, NdtDicomObjectMapper objectMapper,
            OrthancService orthanc, NdtAccessService access)
    {
        this.mapper=mapper;this.objectMapper=objectMapper;this.orthanc=orthanc;this.access=access;
    }
    public List<NdtDicomIntegrityRecord> selectNdtDicomIntegrityRecordList(NdtDicomIntegrityRecord query)
    {
        access.applyTaskListScope(query);return mapper.selectNdtDicomIntegrityRecordList(query);
    }
    public NdtDicomIntegrityRecord selectNdtDicomIntegrityRecordById(Long id)
    {
        NdtDicomIntegrityRecord value=mapper.selectNdtDicomIntegrityRecordById(id);
        if(value!=null && value.getObjectId()!=null)
        {
            NdtDicomObject object=objectMapper.selectById(value.getObjectId());
            if(object!=null)access.checkViewTask(object.getTaskId());
        }
        return value;
    }
    public String calculateSha256(byte[] content)
    {
        try
        {
            byte[] hash=MessageDigest.getInstance("SHA-256").digest(content);
            StringBuilder value=new StringBuilder(hash.length*2);
            for(byte item:hash)value.append(String.format("%02x",item));
            return value.toString();
        }
        catch(NoSuchAlgorithmException ex){throw new ServiceException("当前JDK不支持SHA-256算法");}
    }
    @Transactional(rollbackFor=Exception.class)
    public NdtDicomIntegrityRecord verifyByObjectId(Long objectId)
    {
        NdtDicomObject object=objectMapper.selectById(objectId);
        if(object==null)throw new ServiceException("DICOM对象不存在");
        access.checkViewTask(object.getTaskId());
        NdtDicomIntegrityRecord record=mapper.selectNdtDicomIntegrityRecordBySopUid(object.getSopInstanceUid());
        if(record==null)throw new ServiceException("完整性记录不存在");
        String hash=calculateSha256(orthanc.downloadInstanceFile(object.getOrthancInstanceId()));
        record.setVerifyStatus(hash.equalsIgnoreCase(record.getFileSha256())?NdtConstants.INTEGRITY_STATUS_PASS:NdtConstants.INTEGRITY_STATUS_FAIL);
        record.setLastVerifyTime(new Date());mapper.updateNdtDicomIntegrityRecord(record);return record;
    }
    public String signContent(String content){return Base64.getEncoder().encodeToString(calculateSha256(content.getBytes()).getBytes());}
    public boolean verifySignature(String content,String signature){return signContent(content).equals(signature);}
}
