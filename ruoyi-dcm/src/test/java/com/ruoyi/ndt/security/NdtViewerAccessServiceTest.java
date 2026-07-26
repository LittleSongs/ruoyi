package com.ruoyi.ndt.security;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.config.NdtProperties;

class NdtViewerAccessServiceTest
{
    @AfterEach
    void tearDown()
    {
        SecurityContextHolder.clearContext();
    }

    @Test
    void authenticatedViewerUsesTaskAccessRules()
    {
        NdtAccessService accessService = Mockito.mock(NdtAccessService.class);
        LoginUser loginUser = new LoginUser(1L, 1L, new SysUser(), null);
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(loginUser, null, loginUser.getAuthorities()));
        NdtViewerAccessService service = new NdtViewerAccessService(accessService, new NdtProperties());

        service.checkReadTask(8L);

        verify(accessService).checkViewTask(8L);
    }

    @Test
    void anonymousViewerIsRejectedByDefault()
    {
        NdtViewerAccessService service = new NdtViewerAccessService(
                Mockito.mock(NdtAccessService.class), new NdtProperties());

        ServiceException exception = assertThrows(ServiceException.class, () -> service.checkReadTask(8L));

        assertEquals(403, exception.getCode());
    }

    @Test
    void anonymousViewerCanBeEnabledForLocalTesting()
    {
        NdtProperties properties = new NdtProperties();
        properties.getSecurity().setAllowAnonymousViewerApi(true);
        NdtAccessService accessService = Mockito.mock(NdtAccessService.class);
        when(accessService.taskExists(8L)).thenReturn(true);
        NdtViewerAccessService service = new NdtViewerAccessService(accessService, properties);

        assertDoesNotThrow(() -> service.checkReadTask(8L));

        verify(accessService).taskExists(8L);
    }
}
