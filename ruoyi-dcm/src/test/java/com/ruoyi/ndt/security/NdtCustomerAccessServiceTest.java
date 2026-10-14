package com.ruoyi.ndt.security;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import java.util.List;
import org.junit.jupiter.api.*;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.util.ReflectionTestUtils;
import com.github.pagehelper.PageHelper;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.ndt.customer.mapper.NdtCustomerAccountMapper;
import com.ruoyi.ndt.task.mapper.NdtInspectionTaskMapper;
import com.ruoyi.ndt.task.mapper.NdtTaskUserMapper;
import com.ruoyi.ndt.task.domain.NdtInspectionTask;

class NdtCustomerAccessServiceTest
{
    NdtAccessService access;
    NdtCustomerAccountMapper accounts;
    NdtInspectionTaskMapper tasks;
    NdtTaskUserMapper assignments;

    @BeforeEach void setUp()
    {
        accounts=mock(NdtCustomerAccountMapper.class); tasks=mock(NdtInspectionTaskMapper.class);
        assignments=mock(NdtTaskUserMapper.class); access=new NdtAccessService();
        ReflectionTestUtils.setField(access,"customerAccountMapper",accounts);
        ReflectionTestUtils.setField(access,"taskMapper",tasks);
        ReflectionTestUtils.setField(access,"taskUserMapper",assignments);
        SysRole role=new SysRole(); role.setRoleKey("admin");
        SysUser user=new SysUser(); user.setUserId(123L); user.setRoles(List.of(role));
        LoginUser login=new LoginUser(); login.setUserId(123L); login.setUser(user);
        SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(login,null,List.of()));
        when(accounts.selectBindingCustomerId(123L)).thenReturn(3L);
        when(accounts.selectActiveCustomerId(123L)).thenReturn(3L);
    }
    @AfterEach void clean() { SecurityContextHolder.clearContext(); PageHelper.clearPage(); }

    @Test void companyScopeOverridesPrivilegedRolesAndClientFilters()
    {
        BaseEntity query=new BaseEntity(); query.getParams().put("scopeType","ALL"); query.getParams().put("scopeCustomerId",4L);
        var page=PageHelper.startPage(2,10);
        access.applyTaskListScope(query);
        assertEquals("CUSTOMER",query.getParams().get("scopeType"));
        assertEquals(3L,query.getParams().get("scopeCustomerId"));
        assertSame(page,PageHelper.getLocalPage());
    }
    @Test void onlyOwnCompanyTasksCanBeViewedEvenWithAssignments()
    {
        NdtInspectionTask own=new NdtInspectionTask(); own.setCustomerId(3L);
        NdtInspectionTask other=new NdtInspectionTask(); other.setCustomerId(4L);
        when(tasks.selectNdtInspectionTaskById(1L)).thenReturn(own);
        when(tasks.selectNdtInspectionTaskById(2L)).thenReturn(other);
        when(assignments.countTaskPermission(any(),any(),any())).thenReturn(1);
        assertTrue(access.canViewTask(1L)); assertFalse(access.canViewTask(2L));
        verifyNoInteractions(assignments);
    }
    @Test void customersCannotWriteEvenIfTheyHaveAdminRoleOrTaskAssignments()
    {
        assertFalse(access.canUploadTask(1L)); assertFalse(access.canEvaluateTask(1L)); assertFalse(access.canManageTask(1L));
        verifyNoInteractions(assignments);
    }
    @Test void disabledOrUnboundCustomerHasNoScope()
    {
        when(accounts.selectActiveCustomerId(123L)).thenReturn(null);
        BaseEntity query=new BaseEntity(); access.applyTaskListScope(query);
        assertEquals("NONE",query.getParams().get("scopeType"));
        NdtInspectionTask own=new NdtInspectionTask(); own.setCustomerId(3L);
        when(tasks.selectNdtInspectionTaskById(1L)).thenReturn(own);
        assertFalse(access.canViewTask(1L));
    }
}
