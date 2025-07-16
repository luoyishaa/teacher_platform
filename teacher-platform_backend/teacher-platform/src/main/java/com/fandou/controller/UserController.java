package com.fandou.controller;

import com.fandou.aop.Log; // 引入自定义的日志注解
import com.fandou.entity.User;
import com.fandou.service.UserService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.fandou.dto.UserUpdateDto;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/users")
public class UserController {
    private UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    //查询用户列表
    @GetMapping("")
    @PreAuthorize("hasAuthority('ROLE_admin')")
    public ApiResponse<PageResult<User>> getAllUsers(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        PageResult<User> result = userService.getAllUsers(pageNum, pageSize);
        return ApiResponse.success(result);
    }

    //删除用户
    @DeleteMapping("/{username}")
    @PreAuthorize("hasAnyAuthority('ROLE_admin')")
    @Log(description="删除用户")
    public ApiResponse<?> deleteUser(@PathVariable String username) {
        try {
            boolean success = userService.deletebyUsername(username);
            if (success) {
                return ApiResponse.success("删除成功");
            } else {
                return ApiResponse.error(404, "用户不存在");
            }
        } catch (Exception e) {
            return ApiResponse.error(500, "删除用户时发生错误: " + e.getMessage());
        }
    }

    //修改用户信息
    @PutMapping("/{username}")
//    @PreAuthorize("hasAnyAuthority('ROLE_admin')")
    @Log(description="修改用户")
    public ApiResponse<User> updateUser(@PathVariable String username, @RequestBody UserUpdateDto updateDto) {
        try {
            // 执行更新
            User updatedUser = userService.updateUserInfo(username, updateDto);
            // 安全处理：移除敏感信息
            updatedUser.setPassword(null);
            return ApiResponse.success("用户信息更新成功", updatedUser);
        } catch (RuntimeException e) {
            return ApiResponse.error(400, e.getMessage());
        }
    }
}

