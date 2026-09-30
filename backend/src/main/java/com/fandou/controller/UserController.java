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
import com.fandou.exception.BusinessException;
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
        if (!userService.deletebyUsername(username)) throw new BusinessException(404, "用户不存在");
        return ApiResponse.success("删除成功");
    }

    //修改用户信息
    // 管理员可以修改任意用户，普通用户只能修改自己的信息。
    // 这里不能只靠角色注解：两个教师都有 ROLE_teacher，但 A 不该能改 B 的账号，
    // 所以要在业务入口再做一次数据级归属校验。
    @PutMapping("/{username}")
    @Log(description="修改用户")
    public ApiResponse<User> updateUser(@PathVariable String username, @RequestBody UserUpdateDto updateDto) {
            User currentUser = userService.getCurrentUser();
            if (currentUser == null) {
                throw new BusinessException(401, "未登录或登录状态已失效");
            }
            boolean isAdmin = "admin".equals(currentUser.getRole());
            if (!isAdmin && !currentUser.getUsername().equals(username)) {
                throw new BusinessException(403, "无权修改其他用户的信息");
            }

            // 执行更新
            User updatedUser = userService.updateUserInfo(username, updateDto);
            // 安全处理：移除敏感信息
            updatedUser.setPassword(null);
            return ApiResponse.success("用户信息更新成功", updatedUser);
    }
}

