package com.ruoyi.ndt.evaluation.domain;

import java.util.ArrayList;
import java.util.List;

public class NdtEvaluationHistoryResponse
{
    private List<NdtEvaluationHistoryPart> parts = new ArrayList<>();

    public List<NdtEvaluationHistoryPart> getParts() { return parts; }
    public void setParts(List<NdtEvaluationHistoryPart> value) { this.parts = value; }
}
