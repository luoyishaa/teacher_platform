package com.fandou.controller;

import com.fandou.aop.Log; // 引入自定义的日志注解
import com.fandou.dto.LoginDto;
import com.fandou.dto.RegisterDto;
import com.fandou.entity.User;
import com.fandou.service.AuthService;
import com.fandou.service.UserService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.LoginVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    private final UserService userService;

    @Autowired
    public AuthController(AuthService authService,UserService userService) {
        this.authService = authService;
        this.userService = userService;
    }

    @PostMapping("/register")
    @Log(description = "用户注册") // 为注册操作添加日志记录
//    @PreAuthorize("hasAuthority('ROLE_teacher')")
    public ApiResponse<User> register(@Validated @RequestBody RegisterDto registerDto) {
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
            return ApiResponse.error(40101, "用户名或密码错误");
        }
    }
}