package com.ruoyi.dcm.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Current evaluation for a DICOM study.
 */
public class DcmEvaluation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long studyId;
    private Long seriesId;
    private Long instanceId;
    private Long evaluatorId;
    private String evaluatorName;
    private String imageQualityResult;
    private String defectResult;
    private String defectLevel;
    private String defectDescription;
    private String evaluationConclusion;
    private String evaluationStatus;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date evaluationTime;
    private String delFlag;
    private String studyInstanceUid;
    private String patientName;
    private String studyDescription;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getStudyId() { return studyId; }
    public void setStudyId(Long studyId) { this.studyId = studyId; }
    public Long getSeriesId() { return seriesId; }
    public void setSeriesId(Long seriesId) { this.seriesId = seriesId; }
    public Long getInstanceId() { return instanceId; }
    public void setInstanceId(Long instanceId) { this.instanceId = instanceId; }
    public Long getEvaluatorId() { return evaluatorId; }
    public void setEvaluatorId(Long evaluatorId) { this.evaluatorId = evaluatorId; }
    public String getEvaluatorName() { return evaluatorName; }
    public void setEvaluatorName(String evaluatorName) { this.evaluatorName = evaluatorName; }
    public String getImageQualityResult() { return imageQualityResult; }
    public void setImageQualityResult(String imageQualityResult) { this.imageQualityResult = imageQualityResult; }
    public String getDefectResult() { return defectResult; }
    public void setDefectResult(String defectResult) { this.defectResult = defectResult; }
    public String getDefectLevel() { return defectLevel; }
    public void setDefectLevel(String defectLevel) { this.defectLevel = defectLevel; }
    public String getDefectDescription() { return defectDescription; }
    public void setDefectDescription(String defectDescription) { this.defectDescription = defectDescription; }
    public String getEvaluationConclusion() { return evaluationConclusion; }
    public void setEvaluationConclusion(String evaluationConclusion) { this.evaluationConclusion = evaluationConclusion; }
    public String getEvaluationStatus() { return evaluationStatus; }
    public void setEvaluationStatus(String evaluationStatus) { this.evaluationStatus = evaluationStatus; }
    public Date getEvaluationTime() { return evaluationTime; }
    public void setEvaluationTime(Date evaluationTime) { this.evaluationTime = evaluationTime; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getStudyDescription() { return studyDescription; }
    public void setStudyDescription(String studyDescription) { this.studyDescription = studyDescription; }
}
