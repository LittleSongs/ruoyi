package com.ruoyi.ndt.task.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.domain.NdtTaskUser;
import com.ruoyi.ndt.task.dto.NdtInspectionTaskSaveDto;
import com.ruoyi.ndt.task.service.INdtInspectionTaskService;

@RestController
@RequestMapping("/ndt/task")
public class NdtInspectionTaskController extends BaseController
{
    private final INdtInspectionTaskService service;
    public NdtInspectionTaskController(INdtInspectionTaskService service) { this.service = service; }
    @PreAuthorize("@ss.hasPermi('ndt:task:list')")
    @GetMapping("/list") public TableDataInfo list(NdtInspectionTask query) { startPage(); return getDataTable(service.selectNdtInspectionTaskList(query)); }
    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{id}") public AjaxResult get(@PathVariable Long id) { return success(service.selectNdtInspectionTaskById(id)); }
    @PreAuthorize("@ss.hasPermi('ndt:task:add')")
    @Log(title="NDT检测任务",businessType=BusinessType.INSERT)
    @PostMapping public AjaxResult add(@RequestBody NdtInspectionTaskSaveDto dto) { return toAjax(service.insertNdtInspectionTask(dto,getUserId(),getUsername())); }
    @PreAuthorize("@ss.hasPermi('ndt:task:edit')")
    @Log(title="NDT检测任务",businessType=BusinessType.UPDATE)
    @PutMapping public AjaxResult edit(@RequestBody NdtInspectionTaskSaveDto dto) { return toAjax(service.updateNdtInspectionTask(dto,getUsername())); }
    @PreAuthorize("@ss.hasPermi('ndt:task:remove')")
    @Log(title="NDT检测任务",businessType=BusinessType.DELETE)
    @DeleteMapping("/{ids}") public AjaxResult remove(@PathVariable Long[] ids) { return toAjax(service.deleteNdtInspectionTaskByIds(ids)); }
    @PreAuthorize("@ss.hasPermi('ndt:task:assign')")
    @PutMapping("/{taskId}/users") public AjaxResult assign(@PathVariable Long taskId,@RequestBody List<NdtTaskUser> users) { return toAjax(service.assignTaskUsers(taskId,users,getUsername())); }
    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{taskId}/users") public AjaxResult users(@PathVariable Long taskId) { return success(service.selectNdtTaskUsersByTaskId(taskId)); }
    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{taskId}/object-tree")
    public AjaxResult tree(@PathVariable Long taskId,
            @RequestParam(required = false) Long studyId)
    {
        return success(service.selectObjectTree(taskId, studyId));
    }
}
