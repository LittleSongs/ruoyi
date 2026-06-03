package com.ruoyi.ndt.evaluation.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import com.ruoyi.ndt.dicom.domain.NdtDicomUploadResult;

/**
 * Batch evaluation and DICOM SR submission result.
 */
public class NdtEvaluationSrSubmitResult implements Serializable
{
    private static final long serialVersionUID = 1L;

    private List<NdtEvaluation> evaluations = new ArrayList<>();
    private NdtDicomUploadResult srReport;

    public List<NdtEvaluation> getEvaluations() { return evaluations; }
    public void setEvaluations(List<NdtEvaluation> evaluations) { this.evaluations = evaluations; }
    public NdtDicomUploadResult getSrReport() { return srReport; }
    public void setSrReport(NdtDicomUploadResult srReport) { this.srReport = srReport; }
}
