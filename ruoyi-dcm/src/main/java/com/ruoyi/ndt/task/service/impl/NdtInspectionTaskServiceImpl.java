package com.ruoyi.ndt.task.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.config.NdtProperties;
import com.ruoyi.ndt.security.NdtAccessService;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.domain.NdtTaskUser;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;
import com.ruoyi.ndt.task.mapper.NdtTaskUserMapper;
import com.ruoyi.ndt.task.service.INdtInspectionTaskService;

@Service
public class NdtInspectionTaskServiceImpl implements INdtInspectionTaskService
{
    @Autowired
    private NdtInspectionTaskMapper taskMapper;

    @Autowired
    private NdtTaskUserMapper taskUserMapper;

    @Autowired
    private NdtAccessService accessService;

    @Autowired
    private NdtProperties properties;

    @Override
    public List<NdtInspectionTask> selectNdtInspectionTaskList(NdtInspectionTask task)
    {
        accessService.applyTaskListScope(task);
        return taskMapper.selectNdtInspectionTaskList(task);
    }

    @Override
    public List<NdtInspectionTask> selectPublicNdtInspectionTaskList(NdtInspectionTask task)
    {
        return taskMapper.selectPublicNdtInspectionTaskList(task);
    }

    @Override
    public NdtInspectionTask selectNdtInspectionTaskById(Long id)
    {
        accessService.checkViewTask(id);
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(id);
        if (task != null)
        {
            task.setTaskUsers(taskUserMapper.selectNdtTaskUsersByTaskId(id));
            if (StringUtils.isNotEmpty(task.getStudyInstanceUid()))
            {
                task.setOhifViewerUrl(properties.buildViewerUrl(
                        task.getStudyInstanceUid(),
                        id,
                        String.valueOf(id),
                        accessService.canEvaluateTask(id)));
            }
        }
        return task;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertNdtInspectionTask(NdtInspectionTask task, Long userId, String username)
    {
        validateTask(task);
        if (StringUtils.isEmpty(task.getTaskNo()))
        {
            task.setTaskNo("NDT" + DateUtils.dateTimeNow() + IdUtils.fastSimpleUUID().substring(0, 6));
        }
        if (taskMapper.selectNdtInspectionTaskByTaskNo(task.getTaskNo()) != null)
        {
            throw new ServiceException("检测任务编号已存在");
        }
        if (StringUtils.isEmpty(task.getStatus()))
        {
            task.setStatus(NdtConstants.TASK_STATUS_DRAFT);
        }
        if (StringUtils.isEmpty(task.getIsPublicSample()))
        {
            task.setIsPublicSample(NdtConstants.NO);
        }
        task.setCreateBy(username);
        task.setUpdateBy(username);
        task.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        int rows = taskMapper.insertNdtInspectionTask(task);
        NdtTaskUser creator = new NdtTaskUser();
        creator.setTaskId(task.getId());
        creator.setUserId(userId);
        creator.setTaskRole(NdtConstants.TASK_ROLE_CREATOR);
        creator.setCanEvaluate(NdtConstants.NO);
        creator.setCanUpload(NdtConstants.YES);
        creator.setCanView(NdtConstants.YES);
        creator.setAssignedBy(username);
        taskUserMapper.insertNdtTaskUser(creator);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNdtInspectionTask(NdtInspectionTask task, String username)
    {
        accessService.checkManageTask(task.getId());
        validateTask(task);
        if (StringUtils.isEmpty(task.getStatus()))
        {
            task.setStatus(NdtConstants.TASK_STATUS_DRAFT);
        }
        if (StringUtils.isEmpty(task.getIsPublicSample()))
        {
            task.setIsPublicSample(NdtConstants.NO);
        }
        task.setUpdateBy(username);
        task.setDelFlag(NdtConstants.DEL_FLAG_NORMAL);
        return taskMapper.updateNdtInspectionTask(task);
    }

    @Override
    public int deleteNdtInspectionTaskByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            accessService.checkManageTask(id);
        }
        return taskMapper.softDeleteNdtInspectionTaskByIds(ids);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int assignTaskUsers(Long taskId, List<NdtTaskUser> users, String username)
    {
        accessService.checkManageTask(taskId);
        taskUserMapper.deleteNdtTaskUsersByTaskId(taskId);
        int rows = 0;
        if (users != null)
        {
            for (NdtTaskUser user : users)
            {
                normalizeTaskUser(taskId, user, username);
                rows += taskUserMapper.insertNdtTaskUser(user);
            }
        }
        taskMapper.updateNdtInspectionTaskStatus(taskId, NdtConstants.TASK_STATUS_ASSIGNED, username);
        return rows > 0 ? rows : 1;
    }

    @Override
    public List<NdtTaskUser> selectNdtTaskUsersByTaskId(Long taskId)
    {
        accessService.checkViewTask(taskId);
        return taskUserMapper.selectNdtTaskUsersByTaskId(taskId);
    }

    @Override
    public String getOhifViewerUrl(Long taskId)
    {
        accessService.checkViewTask(taskId);
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(taskId);
        if (task == null || StringUtils.isEmpty(task.getStudyInstanceUid()))
        {
            throw new ServiceException("该任务尚未绑定StudyInstanceUID");
        }
        return properties.buildViewerUrl(task.getStudyInstanceUid(), taskId,
                String.valueOf(taskId), accessService.canEvaluateTask(taskId));
    }

    private void validateTask(NdtInspectionTask task)
    {
        if (StringUtils.isEmpty(task.getTaskName()))
        {
            throw new ServiceException("任务名称不能为空");
        }
        if (task.getCustomerDeptId() == null)
        {
            throw new ServiceException("客户部门不能为空");
        }
    }

    private void normalizeTaskUser(Long taskId, NdtTaskUser taskUser, String username)
    {
        if (taskUser.getUserId() == null)
        {
            throw new ServiceException("分配用户不能为空");
        }
        if (!isSupportedTaskRole(taskUser.getTaskRole()))
        {
            throw new ServiceException("任务角色仅支持 CREATOR、UPLOADER、EVALUATOR、VIEWER");
        }
        taskUser.setTaskId(taskId);
        taskUser.setAssignedBy(username);
        if (StringUtils.isEmpty(taskUser.getCanView()))
        {
            taskUser.setCanView(NdtConstants.YES);
        }
        if (NdtConstants.TASK_ROLE_EVALUATOR.equals(taskUser.getTaskRole()))
        {
            taskUser.setCanEvaluate(NdtConstants.YES);
        }
        if (NdtConstants.TASK_ROLE_UPLOADER.equals(taskUser.getTaskRole()))
        {
            taskUser.setCanUpload(NdtConstants.YES);
        }
        if (StringUtils.isEmpty(taskUser.getCanEvaluate()))
        {
            taskUser.setCanEvaluate(NdtConstants.NO);
        }
        if (StringUtils.isEmpty(taskUser.getCanUpload()))
        {
            taskUser.setCanUpload(NdtConstants.NO);
        }
    }

    private boolean isSupportedTaskRole(String role)
    {
        return NdtConstants.TASK_ROLE_CREATOR.equals(role)
                || NdtConstants.TASK_ROLE_UPLOADER.equals(role)
                || NdtConstants.TASK_ROLE_EVALUATOR.equals(role)
                || NdtConstants.TASK_ROLE_VIEWER.equals(role);
    }
}
