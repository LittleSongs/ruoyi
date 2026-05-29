package com.ruoyi.ndt.task.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * Task user assignment.
 */
public class NdtTaskUser extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long taskId;
    private Long userId;
    private String userName;
    private String nickName;
    private String taskRole;
    private String canEvaluate;
    private String canUpload;
    private String canView;
    private String assignedBy;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date assignedTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }
    public String getTaskRole() { return taskRole; }
    public void setTaskRole(String taskRole) { this.taskRole = taskRole; }
    public String getCanEvaluate() { return canEvaluate; }
    public void setCanEvaluate(String canEvaluate) { this.canEvaluate = canEvaluate; }
    public String getCanUpload() { return canUpload; }
    public void setCanUpload(String canUpload) { this.canUpload = canUpload; }
    public String getCanView() { return canView; }
    public void setCanView(String canView) { this.canView = canView; }
    public String getAssignedBy() { return assignedBy; }
    public void setAssignedBy(String assignedBy) { this.assignedBy = assignedBy; }
    public Date getAssignedTime() { return assignedTime; }
    public void setAssignedTime(Date assignedTime) { this.assignedTime = assignedTime; }
}
