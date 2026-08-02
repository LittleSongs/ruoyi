package com.ruoyi.ndt.report.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.integrity.service.INdtIntegrityService;
import com.ruoyi.ndt.report.domain.NdtTaskReport;
import com.ruoyi.ndt.report.mapper.NdtTaskReportMapper;
import com.ruoyi.ndt.report.service.INdtTaskReportService;
import com.ruoyi.ndt.security.NdtAccessService;

@Service
public class NdtTaskReportServiceImpl implements INdtTaskReportService
{
    private final NdtTaskReportMapper mapper;
    private final INdtIntegrityService integrityService;
    private final NdtAccessService access;
    public NdtTaskReportServiceImpl(NdtTaskReportMapper mapper,
            INdtIntegrityService integrityService, NdtAccessService access)
    {
        this.mapper = mapper; this.integrityService = integrityService; this.access = access;
    }
    public List<NdtTaskReport> selectList(NdtTaskReport query)
    {
        access.applyTaskListScope(query); return mapper.selectList(query);
    }
    public NdtTaskReport selectById(Long id)
    {
        NdtTaskReport value = require(id); access.checkViewTask(value.getTaskId()); return value;
    }
    @Transactional(rollbackFor = Exception.class)
    public NdtTaskReport upload(Long taskId, MultipartFile file, Long userId, String username)
    {
        access.checkManageTask(taskId);
        if (file == null || file.isEmpty()) throw new ServiceException("报告文件不能为空");
        String original = StringUtils.isEmpty(file.getOriginalFilename()) ? "report.pdf" : file.getOriginalFilename();
        if (!original.toLowerCase().endsWith(".pdf")) throw new ServiceException("报告仅支持PDF文件");
        byte[] content;
        try { content = file.getBytes(); } catch (IOException ex) { throw new ServiceException("读取报告失败"); }
        int next = mapper.selectMaxNumericVersion(taskId) + 1;
        String safeName = original.replaceAll("[^a-zA-Z0-9._\\-\\u4e00-\\u9fa5]", "_");
        Path root = Paths.get(RuoYiConfig.getProfile()).toAbsolutePath().normalize()
                .resolve("ndt-reports").resolve(String.valueOf(taskId));
        Path target = root.resolve("v" + next + "-" + safeName).normalize();
        if (!target.startsWith(root)) throw new ServiceException("报告路径不合法");
        try { Files.createDirectories(root); Files.write(target, content); }
        catch (IOException ex) { throw new ServiceException("保存报告文件失败"); }
        NdtTaskReport report = new NdtTaskReport();
        report.setTaskId(taskId); report.setReportName(original); report.setVersion(String.valueOf(next));
        report.setFilePath(target.toString()); report.setSha256(integrityService.calculateSha256(content));
        report.setStatus(NdtConstants.REPORT_STATUS_DRAFT); report.setGenerateBy(userId);
        report.setGenerateTime(new Date()); report.setCreateBy(username); report.setUpdateBy(username);
        try { mapper.insert(report); }
        catch (RuntimeException ex) { safeDelete(target); throw ex; }
        return mapper.selectById(report.getId());
    }
    public byte[] download(Long id)
    {
        NdtTaskReport report = selectById(id);
        if (StringUtils.isEmpty(report.getFilePath())) throw new ServiceException("报告文件路径为空");
        try { return Files.readAllBytes(Paths.get(report.getFilePath())); }
        catch (IOException ex) { throw new ServiceException("读取报告文件失败"); }
    }
    public int updateStatus(Long id, String status, String username)
    {
        NdtTaskReport report = require(id); access.checkManageTask(report.getTaskId());
        if (!List.of(NdtConstants.REPORT_STATUS_DRAFT, NdtConstants.REPORT_STATUS_RELEASED).contains(status))
            throw new ServiceException("报告状态仅支持DRAFT或RELEASED");
        return mapper.updateStatus(id, status, username);
    }
    public int delete(Long id)
    {
        NdtTaskReport report = require(id); access.checkManageTask(report.getTaskId());
        int rows = mapper.deleteById(id);
        if (rows > 0 && StringUtils.isNotEmpty(report.getFilePath())) safeDelete(Paths.get(report.getFilePath()));
        return rows;
    }
    private NdtTaskReport require(Long id)
    {
        NdtTaskReport value = mapper.selectById(id);
        if (value == null) throw new ServiceException("报告不存在"); return value;
    }
    private void safeDelete(Path path) { try { Files.deleteIfExists(path); } catch (IOException ignored) { } }
}
