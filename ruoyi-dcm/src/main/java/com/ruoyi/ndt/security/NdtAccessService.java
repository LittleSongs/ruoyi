package com.ruoyi.ndt.security;

import java.util.Collection;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;
import com.ruoyi.ndt.task.mapper.NdtTaskUserMapper;

/**
 * Centralized NDT business access checks.
 */
@Service
public class NdtAccessService
{
    @Autowired
    private NdtInspectionTaskMapper taskMapper;

    @Autowired
    private NdtTaskUserMapper taskUserMapper;

    public void applyTaskListScope(BaseEntity entity)
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            entity.getParams().put("scopeType", "ALL");
            return;
        }
        if (hasRole(loginUser, NdtConstants.ROLE_INSPECTOR))
        {
            entity.getParams().put("scopeType", "ASSIGNED");
            entity.getParams().put("scopeUserId", loginUser.getUserId());
            return;
        }
        if (hasRole(loginUser, NdtConstants.ROLE_CUSTOMER))
        {
            entity.getParams().put("scopeType", "CUSTOMER_DEPT");
            entity.getParams().put("scopeDeptId", loginUser.getDeptId());
            return;
        }
        entity.getParams().put("scopeType", "NONE");
    }

    public boolean canViewTask(Long taskId)
    {
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(taskId);
        if (task == null)
        {
            return false;
        }
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        if (hasRole(loginUser, NdtConstants.ROLE_CUSTOMER)
                && task.getCustomerDeptId() != null
                && task.getCustomerDeptId().equals(loginUser.getDeptId()))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_view");
    }

    public boolean canUploadTask(Long taskId)
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_upload");
    }

    public boolean canEvaluateTask(Long taskId)
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_evaluate");
    }

    public boolean canManageTask(Long taskId)
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        return taskUserMapper.countTaskRole(taskId, loginUser.getUserId(), NdtConstants.TASK_ROLE_CREATOR) > 0;
    }

    public void checkViewTask(Long taskId)
    {
        if (!canViewTask(taskId))
        {
            throw new ServiceException("无权访问该检测任务");
        }
    }

    public void checkUploadTask(Long taskId)
    {
        if (!canUploadTask(taskId))
        {
            throw new ServiceException("无权上传该检测任务的DICOM文件");
        }
    }

    public void checkEvaluateTask(Long taskId)
    {
        if (!canEvaluateTask(taskId))
        {
            throw new ServiceException("当前用户未被分配该任务的评定权限");
        }
    }

    public void checkManageTask(Long taskId)
    {
        if (!canManageTask(taskId))
        {
            throw new ServiceException("无权管理该检测任务");
        }
    }

    private boolean hasTaskPermission(Long taskId, Long userId, String permissionField)
    {
        return taskUserMapper.countTaskPermission(taskId, userId, permissionField) > 0;
    }

    private boolean isSuperAdmin(LoginUser loginUser)
    {
        return loginUser != null && (SecurityUtils.isAdmin(loginUser.getUserId())
                || hasRole(loginUser, NdtConstants.ROLE_SUPER_ADMIN));
    }

    private boolean hasRole(LoginUser loginUser, String roleKey)
    {
        if (loginUser == null || loginUser.getUser() == null || loginUser.getUser().getRoles() == null)
        {
            return false;
        }
        Collection<String> roles = loginUser.getUser().getRoles().stream()
                .map(SysRole::getRoleKey)
                .filter(StringUtils::isNotEmpty)
                .collect(Collectors.toSet());
        return roles.contains(roleKey);
    }
}
