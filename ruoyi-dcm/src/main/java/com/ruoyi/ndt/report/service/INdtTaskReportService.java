package com.ruoyi.ndt.report.service;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.ndt.report.domain.NdtTaskReport;

public interface INdtTaskReportService
{
    List<NdtTaskReport> selectList(NdtTaskReport query);
    NdtTaskReport selectById(Long id);
    NdtTaskReport upload(Long taskId, MultipartFile file, Long userId, String username);
    byte[] download(Long id);
    int updateStatus(Long id, String status, String username);
    int delete(Long id);
}
