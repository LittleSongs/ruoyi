package com.ruoyi.ndt.integrity.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * DICOM integrity verification record.
 */
public class NdtDicomIntegrityRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long dicomInstanceId;
    private String studyInstanceUid;
    private String seriesInstanceUid;
    private String sopInstanceUid;
    private String orthancInstanceId;
    private String pixelDataSha256;
    private String metadataSha256;
    private String fileSha256;
    private String signedContent;
    private String signatureAlgorithm;
    private String signatureValue;
    private String publicKeyId;
    private Long importUserId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date importTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date lastVerifyTime;
    private String verifyStatus;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getDicomInstanceId() { return dicomInstanceId; }
    public void setDicomInstanceId(Long dicomInstanceId) { this.dicomInstanceId = dicomInstanceId; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
    public String getPixelDataSha256() { return pixelDataSha256; }
    public void setPixelDataSha256(String pixelDataSha256) { this.pixelDataSha256 = pixelDataSha256; }
    public String getMetadataSha256() { return metadataSha256; }
    public void setMetadataSha256(String metadataSha256) { this.metadataSha256 = metadataSha256; }
    public String getFileSha256() { return fileSha256; }
    public void setFileSha256(String fileSha256) { this.fileSha256 = fileSha256; }
    public String getSignedContent() { return signedContent; }
    public void setSignedContent(String signedContent) { this.signedContent = signedContent; }
    public String getSignatureAlgorithm() { return signatureAlgorithm; }
    public void setSignatureAlgorithm(String signatureAlgorithm) { this.signatureAlgorithm = signatureAlgorithm; }
    public String getSignatureValue() { return signatureValue; }
    public void setSignatureValue(String signatureValue) { this.signatureValue = signatureValue; }
    public String getPublicKeyId() { return publicKeyId; }
    public void setPublicKeyId(String publicKeyId) { this.publicKeyId = publicKeyId; }
    public Long getImportUserId() { return importUserId; }
    public void setImportUserId(Long importUserId) { this.importUserId = importUserId; }
    public Date getImportTime() { return importTime; }
    public void setImportTime(Date importTime) { this.importTime = importTime; }
    public Date getLastVerifyTime() { return lastVerifyTime; }
    public void setLastVerifyTime(Date lastVerifyTime) { this.lastVerifyTime = lastVerifyTime; }
    public String getVerifyStatus() { return verifyStatus; }
    public void setVerifyStatus(String verifyStatus) { this.verifyStatus = verifyStatus; }
}
