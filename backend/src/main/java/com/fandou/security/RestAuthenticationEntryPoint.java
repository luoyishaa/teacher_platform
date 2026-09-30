package com.fandou.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fandou.vo.ApiResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 未认证请求的出口。
 *
 * Spring Security 的过滤器链在 DispatcherServlet 之前执行，所以这里抛出的异常不会被
 * @RestControllerAdvice 接住。如果不自定义，未带令牌访问受保护接口会返回 Spring 默认的
 * 403 错误体，前端拿不到统一的 ApiResponse 结构。这里显式返回 401 加统一响应体。
 */
@Component
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(
                OBJECT_MAPPER.writeValueAsString(ApiResponse.error(401, "未登录或登录状态已失效"))
        );
    }
}
