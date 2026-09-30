package com.fandou.controller;

import com.fandou.aop.Log; // 引入自定义的日志注解
import com.fandou.dto.LoginDto;
import com.fandou.dto.RegisterDto;
import com.fandou.entity.User;
import com.fandou.service.AuthService;
import com.fandou.service.UserService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.LoginVo;
import com.fandou.exception.BusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@RestController
@RequestMapping("/auth")
public class AuthController {

    /** 允许自助注册的角色白名单，管理员不在此列 */
    private static final Set<String> SELF_REGISTER_ROLES =
            new HashSet<>(Arrays.asList("teacher", "student"));

    private final AuthService authService;
    private final UserService userService;

    @Autowired
    public AuthController(AuthService authService,UserService userService) {
        this.authService = authService;
        this.userService = userService;
    }

    @PostMapping("/register")
    @Log(description = "用户注册") // 为注册操作添加日志记录
    public ApiResponse<User> register(@Validated @RequestBody RegisterDto registerDto) {
        // 注册是匿名接口，角色不能由调用方说了算，否则任何人都能直接注册出一个管理员账号。
        // 这里做白名单校验，管理员账号只能由已有管理员在后台创建或直接写入数据库。
        if (!SELF_REGISTER_ROLES.contains(registerDto.getRole())) {
            throw new BusinessException(403, "注册仅支持教师或学生角色");
        }

        User newUser = userService.registerNewUser(registerDto);
        newUser.setPassword(null);
        return ApiResponse.success("注册成功", newUser);
    }

    @PostMapping("/login")
    @Log(description = "用户登录")
    public ApiResponse<LoginVo> login(@Validated @RequestBody LoginDto loginDto) {
        try {
            LoginVo loginVo = authService.login(loginDto.getUsername(), loginDto.getPassword());

            return ApiResponse.success("登录成功", loginVo);

        } catch (AuthenticationException e) {
            // 捕获Spring Security在认证过程中可能抛出的异常
            // 这通常意味着用户名或密码错误
            throw new BusinessException(401, "用户名或密码错误");
        }
    }
}
