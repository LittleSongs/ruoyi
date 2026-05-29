package com.ruoyi.dcm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * DICOM instance index entity.
 */
public class DcmInstance extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long studyId;
    private Long seriesId;
    private String orthancInstanceId;
    private String sopInstanceUid;
    private String instanceNumber;
    private String sopClassUid;
    private String imageType;
    private Integer rows;
    private Integer columns;
    private String pixelSpacing;
    private String sliceLocation;
    private String delFlag;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getStudyId() { return studyId; }
    public void setStudyId(Long studyId) { this.studyId = studyId; }
    public Long getSeriesId() { return seriesId; }
    public void setSeriesId(Long seriesId) { this.seriesId = seriesId; }
    public String getOrthancInstanceId() { return orthancInstanceId; }
    public void setOrthancInstanceId(String orthancInstanceId) { this.orthancInstanceId = orthancInstanceId; }
    public String getSopInstanceUid() { return sopInstanceUid; }
    public void setSopInstanceUid(String sopInstanceUid) { this.sopInstanceUid = sopInstanceUid; }
    public String getInstanceNumber() { return instanceNumber; }
    public void setInstanceNumber(String instanceNumber) { this.instanceNumber = instanceNumber; }
    public String getSopClassUid() { return sopClassUid; }
    public void setSopClassUid(String sopClassUid) { this.sopClassUid = sopClassUid; }
    public String getImageType() { return imageType; }
    public void setImageType(String imageType) { this.imageType = imageType; }
    public Integer getRows() { return rows; }
    public void setRows(Integer rows) { this.rows = rows; }
    public Integer getColumns() { return columns; }
    public void setColumns(Integer columns) { this.columns = columns; }
    public String getPixelSpacing() { return pixelSpacing; }
    public void setPixelSpacing(String pixelSpacing) { this.pixelSpacing = pixelSpacing; }
    public String getSliceLocation() { return sliceLocation; }
    public void setSliceLocation(String sliceLocation) { this.sliceLocation = sliceLocation; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
}
