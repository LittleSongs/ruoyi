package com.ruoyi.ndt.task.domain;

import java.util.List;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * NDT inspection task.
 */
public class NdtInspectionTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String taskNo;
    private String taskName;
    private String workpieceName;
    private Long customerDeptId;
    private String customerDeptName;
    private String studyInstanceUid;
    private String orthancStudyId;
    private String status;
    private String isPublicSample;
    private String delFlag;
    private String ohifViewerUrl;
    private List<NdtTaskUser> taskUsers;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTaskNo() { return taskNo; }
    public void setTaskNo(String taskNo) { this.taskNo = taskNo; }
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    public String getWorkpieceName() { return workpieceName; }
    public void setWorkpieceName(String workpieceName) { this.workpieceName = workpieceName; }
    public Long getCustomerDeptId() { return customerDeptId; }
    public void setCustomerDeptId(Long customerDeptId) { this.customerDeptId = customerDeptId; }
    public String getCustomerDeptName() { return customerDeptName; }
    public void setCustomerDeptName(String customerDeptName) { this.customerDeptName = customerDeptName; }
    public String getStudyInstanceUid() { return studyInstanceUid; }
    public void setStudyInstanceUid(String studyInstanceUid) { this.studyInstanceUid = studyInstanceUid; }
    public String getOrthancStudyId() { return orthancStudyId; }
    public void setOrthancStudyId(String orthancStudyId) { this.orthancStudyId = orthancStudyId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getIsPublicSample() { return isPublicSample; }
    public void setIsPublicSample(String isPublicSample) { this.isPublicSample = isPublicSample; }
    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }
    public String getOhifViewerUrl() { return ohifViewerUrl; }
    public void setOhifViewerUrl(String ohifViewerUrl) { this.ohifViewerUrl = ohifViewerUrl; }
    public List<NdtTaskUser> getTaskUsers() { return taskUsers; }
    public void setTaskUsers(List<NdtTaskUser> taskUsers) { this.taskUsers = taskUsers; }
}
