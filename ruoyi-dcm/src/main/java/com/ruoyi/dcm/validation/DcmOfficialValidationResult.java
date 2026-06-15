package com.ruoyi.dcm.validation;

public class DcmOfficialValidationResult
{
    private String status;
    private Integer exitCode;
    private String stdout;
    private String stderr;

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getExitCode() { return exitCode; }
    public void setExitCode(Integer exitCode) { this.exitCode = exitCode; }
    public String getStdout() { return stdout; }
    public void setStdout(String stdout) { this.stdout = stdout; }
    public String getStderr() { return stderr; }
    public void setStderr(String stderr) { this.stderr = stderr; }
}
