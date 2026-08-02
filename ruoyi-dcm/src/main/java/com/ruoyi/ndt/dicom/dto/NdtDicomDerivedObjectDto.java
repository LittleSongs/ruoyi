package com.ruoyi.ndt.dicom.dto;

import com.ruoyi.ndt.dicom.domain.NdtDicomObject;

public class NdtDicomDerivedObjectDto extends NdtDicomObject
{
    private static final long serialVersionUID = 1L;
    private Long sourceObjectId;
    private String relationType;

    public Long getSourceObjectId() { return sourceObjectId; }
    public void setSourceObjectId(Long sourceObjectId) { this.sourceObjectId = sourceObjectId; }
    public String getRelationType() { return relationType; }
    public void setRelationType(String relationType) { this.relationType = relationType; }
}
