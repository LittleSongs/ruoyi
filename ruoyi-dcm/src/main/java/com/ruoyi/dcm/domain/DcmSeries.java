package com.ruoyi.dcm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * DICOM series index entity.
 */
public class DcmSeries extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long studyId;
    private String orthancSeriesId;
    private String seriesInstanceUid;
    private String seriesNumber;
    private String seriesDescription;
    private String modality;
    private String bodyPartExamined;
    private Integer instanceCount;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getStudyId() { return studyId; }
    public void setStudyId(Long studyId) { this.studyId = studyId; }
    public String getOrthancSeriesId() { return orthancSeriesId; }
    public void setOrthancSeriesId(String orthancSeriesId) { this.orthancSeriesId = orthancSeriesId; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getSeriesNumber() { return seriesNumber; }
    public void setSeriesNumber(String seriesNumber) { this.seriesNumber = seriesNumber; }
    public String getSeriesDescription() { return seriesDescription; }
    public void setSeriesDescription(String seriesDescription) { this.seriesDescription = seriesDescription; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public String getBodyPartExamined() { return bodyPartExamined; }
    public void setBodyPartExamined(String bodyPartExamined) { this.bodyPartExamined = bodyPartExamined; }
    public Integer getInstanceCount() { return instanceCount; }
    public void setInstanceCount(Integer instanceCount) { this.instanceCount = instanceCount; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
