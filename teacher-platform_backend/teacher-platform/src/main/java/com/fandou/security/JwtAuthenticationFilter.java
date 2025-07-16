package com.fandou.security;

import io.jsonwebtoken.ExpiredJwtException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    @Autowired
    private UserDetailsService userDetailsService; // Spring会自动找到UserDetailsServiceImpl

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    // 定义请求头中存放Token的字段名和前缀
    private final String TOKEN_HEADER = "Authorization";
    private final String TOKEN_PREFIX = "Bearer ";

    /**
     * 过滤器的核心方法，所有请求都会经过这里
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // 从HTTP请求头中获取"Authorization"字段的值
        final String authHeader = request.getHeader(TOKEN_HEADER);

        String username = null;
        String authToken = null;

        // 检查Header是否存在，并且是否以 "Bearer " 开头
        if (StringUtils.hasText(authHeader) && authHeader.startsWith(TOKEN_PREFIX)) {
            // 截取掉 "Bearer " 前缀，拿到真正的Token字符串
            authToken = authHeader.substring(TOKEN_PREFIX.length());
            try {
                // 从Token中解析出用户名
                username = jwtTokenUtil.getUsernameFromToken(authToken);
            } catch (IllegalArgumentException e) {
                logger.error("无法获取JWT Token", e);
            } catch (ExpiredJwtException e) {
                logger.warn("JWT Token已过期", e);
            } catch (Exception e) {
                logger.error("JWT Token解析失败", e);
            }
        } else {
            logger.warn("请求头中缺少或格式不正确的Bearer Token");
        }

        // 如果成功获取到用户名，并且当前Security上下文中还没有认证信息
        // SecurityContextHolder.getContext().getAuthentication() == null 是为了防止在一次请求中重复认证
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // 使用UserDetailsService，根据用户名加载用户的详细信息（包括密码和权限）
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);

            // 使用JWT工具类，验证Token是否有效（检查签名是否匹配且Token未过期）
            if (jwtTokenUtil.validateToken(authToken, userDetails)) {

                // 如果Token有效，创建一个代表当前用户的认证凭证
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, // 用户信息主体 (Principal)
                        null,        // 凭证 (Credentials)，因为是JWT认证，所以这里不需要密码
                        userDetails.getAuthorities() // 权限列表
                );

                // 将请求的详细信息（如IP地址）设置到认证凭证中
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // 将这个认证通过的凭证，放入Spring Security的安全上下文中
                // 这样，Spring Security就知道当前请求的用户是谁，以及他有什么权限了
                logger.info("用户 '{}' 认证成功，设置安全上下文", username);
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }

        // 无论认证成功与否，都必须放行请求，让它继续走到下一个过滤器
        filterChain.doFilter(request, response);
    }
}
