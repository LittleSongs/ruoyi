package com.ruoyi.ndt.sr.service;

import com.ruoyi.ndt.evaluation.domain.NdtEvaluation;

/**
 * Extension point for DICOM SR generation.
 */
public interface DicomSrService
{
    /**
     * TODO: Generate a standards-compliant DICOM SR object in a later phase.
     */
    void generateEvaluationSr(NdtEvaluation evaluation);
}
