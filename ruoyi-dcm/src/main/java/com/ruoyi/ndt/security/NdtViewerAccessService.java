package com.ruoyi.ndt.security;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.ndt.config.NdtProperties;

@Service
public class NdtViewerAccessService
{
    private final NdtAccessService accessService;
    private final NdtProperties properties;

    public NdtViewerAccessService(NdtAccessService accessService, NdtProperties properties)
    {
        this.accessService = accessService;
        this.properties = properties;
    }

    public void checkReadTask(Long taskId)
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)
                && authentication.getPrincipal() instanceof LoginUser)
        {
            accessService.checkViewTask(taskId);
            return;
        }
        if (properties.getSecurity().isAllowAnonymousViewerApi() && accessService.taskExists(taskId))
        {
            return;
        }
        throw new ServiceException("Forbidden viewer API access", 403);
    }
}
