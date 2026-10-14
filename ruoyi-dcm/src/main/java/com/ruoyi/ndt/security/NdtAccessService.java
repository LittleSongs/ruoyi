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
import com.ruoyi.ndt.customer.mapper.NdtCustomerAccountMapper;
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

    @Autowired
    private NdtCustomerAccountMapper customerAccountMapper;

    public boolean isCustomerAccount()
    {
        LoginUser user = SecurityUtils.getLoginUser();
        return customerAccountMapper.selectBindingCustomerId(user.getUserId()) != null
                || customerAccountMapper.hasCustomerRole(user.getUserId())
                || hasRole(user, NdtConstants.ROLE_CUSTOMER);
    }

    public Long getActiveCustomerId()
    {
        return customerAccountMapper.selectActiveCustomerId(SecurityUtils.getUserId());
    }

    public void applyTaskListScope(BaseEntity entity)
    {
        com.github.pagehelper.Page<?> page = com.github.pagehelper.PageHelper.getLocalPage();
        com.github.pagehelper.PageHelper.clearPage();
        try { applyScope(entity); }
        finally { if (page != null) com.github.pagehelper.PageHelper.setLocalPage(page); }
    }

    private void applyScope(BaseEntity entity)
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isCustomerAccount())
        {
            Long customerId = getActiveCustomerId();
            entity.getParams().put("scopeType", customerId == null ? "NONE" : "CUSTOMER");
            entity.getParams().put("scopeCustomerId", customerId);
            return;
        }
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            entity.getParams().put("scopeType", "ALL");
            return;
        }
        entity.getParams().put("scopeType", "ASSIGNED");
        entity.getParams().put("scopeUserId", loginUser.getUserId());
    }

    public boolean canViewTask(Long taskId)
    {
        NdtInspectionTask task = taskMapper.selectNdtInspectionTaskById(taskId);
        if (task == null)
        {
            return false;
        }
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isCustomerAccount())
        {
            Long customerId = getActiveCustomerId();
            return customerId != null && customerId.equals(task.getCustomerId());
        }
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_view");
    }

    public boolean canUploadTask(Long taskId)
    {
        if (isCustomerAccount()) return false;
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_upload");
    }

    public boolean canEvaluateTask(Long taskId)
    {
        if (isCustomerAccount()) return false;
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (isSuperAdmin(loginUser) || hasRole(loginUser, NdtConstants.ROLE_COMPANY_ADMIN))
        {
            return true;
        }
        return hasTaskPermission(taskId, loginUser.getUserId(), "can_evaluate");
    }

    public boolean canManageTask(Long taskId)
    {
        if (isCustomerAccount()) return false;
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
            throw new ServiceException("无权访问该检测任务", 403);
        }
    }

    public boolean taskExists(Long taskId)
    {
        return taskId != null && taskMapper.selectNdtInspectionTaskById(taskId) != null;
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
