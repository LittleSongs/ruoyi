package com.ruoyi.ndt.task.service;

import java.util.List;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.domain.NdtTaskUser;

public interface INdtInspectionTaskService
{
    List<NdtInspectionTask> selectNdtInspectionTaskList(NdtInspectionTask task);

    List<NdtInspectionTask> selectPublicNdtInspectionTaskList(NdtInspectionTask task);

    NdtInspectionTask selectNdtInspectionTaskById(Long id);

    int insertNdtInspectionTask(NdtInspectionTask task, Long userId, String username);

    int updateNdtInspectionTask(NdtInspectionTask task, String username);

    int deleteNdtInspectionTaskByIds(Long[] ids);

    int assignTaskUsers(Long taskId, List<NdtTaskUser> users, String username);

    List<NdtTaskUser> selectNdtTaskUsersByTaskId(Long taskId);

    String getOhifViewerUrl(Long taskId);
}
