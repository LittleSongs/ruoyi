package com.ruoyi.ndt.report.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.report.domain.NdtTaskReport;
import com.ruoyi.ndt.report.service.INdtTaskReportService;

@RestController @RequestMapping("/ndt/report")
public class NdtTaskReportController extends BaseController
{
    private final INdtTaskReportService service;
    public NdtTaskReportController(INdtTaskReportService service){this.service=service;}
    @PreAuthorize("@ss.hasPermi('ndt:report:list')") @GetMapping("/list") public TableDataInfo list(NdtTaskReport query){startPage();return getDataTable(service.selectList(query));}
    @PreAuthorize("@ss.hasPermi('ndt:report:query')") @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id){return success(service.selectById(id));}
    @PreAuthorize("@ss.hasPermi('ndt:report:add')") @Log(title="NDT任务报告",businessType=BusinessType.INSERT)
    @PostMapping("/upload") public AjaxResult upload(@RequestParam Long taskId,@RequestParam MultipartFile file){return success(service.upload(taskId,file,getUserId(),getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:report:download')") @GetMapping("/{id}/download")
    public void download(@PathVariable Long id,HttpServletResponse response) throws IOException
    {
        NdtTaskReport report=service.selectById(id);
        String name=URLEncoder.encode(report.getReportName(),StandardCharsets.UTF_8).replace("+","%20");
        response.setContentType(MediaType.APPLICATION_PDF_VALUE);
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION,"attachment; filename*=UTF-8''"+name);
        response.getOutputStream().write(service.download(id));
    }
    @PreAuthorize("@ss.hasPermi('ndt:report:edit')") @PutMapping("/{id}/status")
    public AjaxResult status(@PathVariable Long id,@RequestParam String status){return toAjax(service.updateStatus(id,status,getUsername()));}
    @PreAuthorize("@ss.hasPermi('ndt:report:remove')") @Log(title="NDT任务报告",businessType=BusinessType.DELETE)
    @DeleteMapping("/{id}") public AjaxResult remove(@PathVariable Long id){return toAjax(service.delete(id));}
}
