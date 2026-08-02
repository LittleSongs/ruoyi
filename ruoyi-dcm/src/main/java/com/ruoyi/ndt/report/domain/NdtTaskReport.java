package com.ruoyi.ndt.report.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

public class NdtTaskReport extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    private Long id;
    private Long taskId;
    private String taskName;
    private String reportName;
    private String version;
    private String filePath;
    private String objectKey;
    private String sha256;
    private String status;
    private Long generateBy;
    private String generateName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date generateTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTaskId() { return taskId; }
    public void setTaskId(Long taskId) { this.taskId = taskId; }
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    public String getReportName() { return reportName; }
    public void setReportName(String reportName) { this.reportName = reportName; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public String getObjectKey() { return objectKey; }
    public void setObjectKey(String objectKey) { this.objectKey = objectKey; }
    public String getSha256() { return sha256; }
    public void setSha256(String sha256) { this.sha256 = sha256; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Long getGenerateBy() { return generateBy; }
    public void setGenerateBy(Long generateBy) { this.generateBy = generateBy; }
    public String getGenerateName() { return generateName; }
    public void setGenerateName(String generateName) { this.generateName = generateName; }
    public Date getGenerateTime() { return generateTime; }
    public void setGenerateTime(Date generateTime) { this.generateTime = generateTime; }
}
