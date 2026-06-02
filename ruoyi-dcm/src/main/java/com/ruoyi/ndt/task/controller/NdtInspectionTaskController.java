package com.ruoyi.ndt.task.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.domain.NdtTaskUser;
import com.ruoyi.ndt.task.service.INdtInspectionTaskService;

@RestController
@RequestMapping("/ndt/task")
public class NdtInspectionTaskController extends BaseController
{
    @Autowired
    private INdtInspectionTaskService taskService;

    @PreAuthorize("@ss.hasPermi('ndt:task:list')")
    @GetMapping("/list")
    public TableDataInfo list(NdtInspectionTask task)
    {
        startPage();
        List<NdtInspectionTask> list = taskService.selectNdtInspectionTaskList(task);
        return getDataTable(list);
    }

    @Anonymous
    @GetMapping("/public/list")
    public TableDataInfo publicList(NdtInspectionTask task)
    {
        startPage();
        List<NdtInspectionTask> list = taskService.selectPublicNdtInspectionTaskList(task);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(taskService.selectNdtInspectionTaskById(id));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:add')")
    @Log(title = "NDT检测任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NdtInspectionTask task)
    {
        return toAjax(taskService.insertNdtInspectionTask(task, getUserId(), getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:edit')")
    @Log(title = "NDT检测任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NdtInspectionTask task)
    {
        return toAjax(taskService.updateNdtInspectionTask(task, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:remove')")
    @Log(title = "NDT检测任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(taskService.deleteNdtInspectionTaskByIds(ids));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:assign')")
    @Log(title = "NDT任务分配", businessType = BusinessType.UPDATE)
    @PutMapping("/{taskId}/users")
    public AjaxResult assign(@PathVariable Long taskId, @RequestBody List<NdtTaskUser> users)
    {
        return toAjax(taskService.assignTaskUsers(taskId, users, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:query')")
    @GetMapping("/{taskId}/users")
    public AjaxResult users(@PathVariable Long taskId)
    {
        return success(taskService.selectNdtTaskUsersByTaskId(taskId));
    }

    @PreAuthorize("@ss.hasPermi('ndt:task:ohif')")
    @GetMapping("/{taskId}/ohif")
    public AjaxResult ohif(@PathVariable Long taskId)
    {
        return AjaxResult.success("操作成功", taskService.getOhifViewerUrl(taskId));
    }
}
