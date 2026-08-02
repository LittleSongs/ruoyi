package com.ruoyi.ndt.series.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class NdtDicomSeries extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long studyId;
    private Long workpieceId;
    private Long positionId;
    private String seriesInstanceUid;
    private String modality;
    private String seriesNumber;
    private String seriesDescription;
    private String orthancSeriesId;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getStudyId() { return studyId; }
    public void setStudyId(Long studyId) { this.studyId = studyId; }
    public Long getWorkpieceId() { return workpieceId; }
    public void setWorkpieceId(Long workpieceId) { this.workpieceId = workpieceId; }
    public Long getPositionId() { return positionId; }
    public void setPositionId(Long positionId) { this.positionId = positionId; }
    public String getSeriesInstanceUid() { return seriesInstanceUid; }
    public void setSeriesInstanceUid(String seriesInstanceUid) { this.seriesInstanceUid = seriesInstanceUid; }
    public String getModality() { return modality; }
    public void setModality(String modality) { this.modality = modality; }
    public String getSeriesNumber() { return seriesNumber; }
    public void setSeriesNumber(String seriesNumber) { this.seriesNumber = seriesNumber; }
    public String getSeriesDescription() { return seriesDescription; }
    public void setSeriesDescription(String seriesDescription) { this.seriesDescription = seriesDescription; }
    public String getOrthancSeriesId() { return orthancSeriesId; }
    public void setOrthancSeriesId(String orthancSeriesId) { this.orthancSeriesId = orthancSeriesId; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
