package com.ruoyi.ndt;

import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.ndt.common.NdtConstants;
import com.ruoyi.ndt.customer.domain.NdtCustomerAccount;
import com.ruoyi.ndt.customer.mapper.NdtCustomerAccountMapper;
import com.ruoyi.ndt.customer.mapper.NdtCustomerMapper;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.ISysRoleService;

@Service
public class NdtCustomerAccountService
{
    private final NdtCustomerAccountMapper bindings;
    private final NdtCustomerMapper companies;
    private final ISysUserService users;
    private final ISysRoleService roles;
    private final RedisCache redis;

    public NdtCustomerAccountService(NdtCustomerAccountMapper bindings, NdtCustomerMapper companies,
            ISysUserService users, ISysRoleService roles, RedisCache redis)
    {
        this.bindings=bindings; this.companies=companies; this.users=users; this.roles=roles; this.redis=redis;
    }

    public List<NdtCustomerAccount> list(Long companyId)
    {
        return bindings.selectList(companyId);
    }

    @Transactional
    public int create(Long companyId, NdtCustomerAccountSaveDto dto)
    {
        if (companies.selectByIdForUpdate(companyId) == null) throw new ServiceException("客户公司不存在");
        validatePassword(dto.password);
        SysUser user = fromDto(dto);
        user.setRoleIds(new Long[] { customerRoleId() });
        user.setDeptId(null);
        user.setPostIds(new Long[0]);
        user.setPassword(SecurityUtils.encryptPassword(dto.password));
        user.setPwdUpdateDate(new Date());
        user.setCreateBy(SecurityUtils.getUsername());
        checkUnique(user);
        int result = users.insertUser(user);
        bindings.insert(user.getUserId(), companyId, SecurityUtils.getUsername());
        return result;
    }

    @Transactional
    public int update(Long companyId, Long userId, NdtCustomerAccountSaveDto dto)
    {
        SysUser existing = requireAccount(companyId, userId);
        if (!existing.getUserName().equals(dto.userName)) throw new ServiceException("客户账号登录名不可修改");
        SysUser user = fromDto(dto);
        user.setUserId(userId);
        checkUnique(user);
        // Updates profile only: never rewrites company, department or roles from client input.
        user.setUpdateBy(SecurityUtils.getUsername());
        int result = users.updateUserProfile(user);
        invalidateSessions(userId);
        return result;
    }

    @Transactional
    public int delete(Long companyId, Long userId)
    {
        requireAccount(companyId, userId);
        int result = users.deleteUserByIds(new Long[] { userId });
        invalidateSessions(userId);
        return result;
    }

    public int resetPassword(Long companyId, Long userId, String password)
    {
        requireAccount(companyId, userId);
        validatePassword(password);
        int result = users.resetUserPwd(userId, SecurityUtils.encryptPassword(password));
        invalidateSessions(userId);
        return result;
    }

    private void requireCompany(Long companyId)
    {
        if (companies.selectById(companyId) == null) throw new ServiceException("客户公司不存在");
    }

    private SysUser requireAccount(Long companyId, Long userId)
    {
        requireCompany(companyId);
        Long bound = bindings.selectBindingCustomerId(userId);
        SysUser user = users.selectUserById(userId);
        if (!companyId.equals(bound) || user == null || !"0".equals(user.getDelFlag()))
            throw new ServiceException("该客户公司下不存在此账号");
        return user;
    }

    private SysUser fromDto(NdtCustomerAccountSaveDto dto)
    {
        SysUser user = new SysUser();
        user.setUserName(dto.userName); user.setNickName(dto.nickName); user.setEmail(dto.email);
        user.setPhonenumber(dto.phonenumber); user.setStatus(dto.status); user.setRemark(dto.remark);
        return user;
    }

    private void checkUnique(SysUser user)
    {
        if (!users.checkUserNameUnique(user)) throw new ServiceException("登录账号已存在");
        if (StringUtils.isNotEmpty(user.getPhonenumber()) && !users.checkPhoneUnique(user))
            throw new ServiceException("手机号码已存在");
        if (StringUtils.isNotEmpty(user.getEmail()) && !users.checkEmailUnique(user))
            throw new ServiceException("邮箱已存在");
    }

    private Long customerRoleId()
    {
        return roles.selectRoleAll().stream()
            .filter(role -> NdtConstants.ROLE_CUSTOMER.equals(role.getRoleKey()) && "0".equals(role.getStatus()))
            .map(SysRole::getRoleId).findFirst().orElseThrow(() -> new ServiceException("客户角色未配置或已停用"));
    }

    private void validatePassword(String value)
    {
        if (value == null || value.length() < UserConstants.PASSWORD_MIN_LENGTH
                || value.length() > UserConstants.PASSWORD_MAX_LENGTH)
            throw new ServiceException("密码长度必须为5至20位");
    }

    private void invalidateSessions(Long userId)
    {
        for (String key : redis.keys(CacheConstants.LOGIN_TOKEN_KEY + "*"))
        {
            LoginUser session = redis.getCacheObject(key);
            if (session != null && userId.equals(session.getUserId())) redis.deleteObject(key);
        }
    }
}
