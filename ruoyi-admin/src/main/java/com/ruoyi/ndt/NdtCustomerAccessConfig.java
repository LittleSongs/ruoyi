package com.ruoyi.ndt;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.ndt.security.NdtAccessService;

/** Customers have a separate portal and a strict read-only API boundary, regardless of menu grants. */
@Configuration
public class NdtCustomerAccessConfig implements WebMvcConfigurer
{
    private final NdtAccessService access;
    public NdtCustomerAccessConfig(NdtAccessService access) { this.access=access; }

    @Override
    public void addInterceptors(InterceptorRegistry registry)
    {
        registry.addInterceptor(new HandlerInterceptor()
        {
            @Override
            public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            {
                if (SecurityUtils.getAuthentication() == null
                        || !(SecurityUtils.getAuthentication().getPrincipal() instanceof com.ruoyi.common.core.domain.model.LoginUser)) return true;
                if (!access.isCustomerAccount()) return true;
                if (access.getActiveCustomerId() == null)
                {
                    response.setStatus(403);
                    ServletUtils.renderString(response, com.alibaba.fastjson2.JSON.toJSONString(AjaxResult.error(403, "客户账号、客户角色或所属公司已失效")));
                    return false;
                }
                String path=request.getRequestURI().substring(request.getContextPath().length());
                if (!isAllowedCustomerRequest(request.getMethod(), path))
                {
                    response.setStatus(403);
                    ServletUtils.renderString(response, com.alibaba.fastjson2.JSON.toJSONString(AjaxResult.error(403, "客户账号仅可查看所属公司的图像，不能操作管理后台或创建内容")));
                    return false;
                }
                return true;
            }
        }).addPathPatterns("/**").order(-100);
    }

    public static boolean isAllowedCustomerRequest(String method, String path)
    {
        return "GET".equals(method) && (path.equals("/ndt/viewer/session")
                || path.startsWith("/ndt/viewer/dicom-web/")
                || path.equals("/ndt/study/viewer-context")
                || path.matches("/ndt/task/[0-9]+/object-tree")
                || path.matches("/ndt/dicom/object/[0-9]+/relations")
                || path.equals("/ndt/defect/list") || path.equals("/ndt/evaluation/list"));
    }
}
