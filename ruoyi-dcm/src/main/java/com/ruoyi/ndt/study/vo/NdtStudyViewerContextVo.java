package com.ruoyi.ndt.study.vo;

public class NdtStudyViewerContextVo
{
    private Long taskId;
    private Long studyId;
    private Boolean canEvaluate;
    private Boolean customer;
    public Boolean getCustomer() { return customer; }
    public void setCustomer(Boolean customer) { this.customer = customer; }
    public Boolean getCanView() { return true; }
    public Boolean getCanUseLocalTools() { return true; }
    public Boolean getCanCreateSR() { return canEvaluate; }
    public Boolean getCanCreateReport() { return false; }

    public NdtStudyViewerContextVo(Long taskId, Long studyId, Boolean canEvaluate)
    {
        this.taskId = taskId;
        this.studyId = studyId;
        this.canEvaluate = canEvaluate;
    }

    public Long getTaskId()
    {
        return taskId;
    }

    public void setTaskId(Long taskId)
    {
        this.taskId = taskId;
    }

    public Long getStudyId()
    {
        return studyId;
    }

    public void setStudyId(Long studyId)
    {
        this.studyId = studyId;
    }

    public Boolean getCanEvaluate()
    {
        return canEvaluate;
    }

    public void setCanEvaluate(Boolean canEvaluate)
    {
        this.canEvaluate = canEvaluate;
    }
}
