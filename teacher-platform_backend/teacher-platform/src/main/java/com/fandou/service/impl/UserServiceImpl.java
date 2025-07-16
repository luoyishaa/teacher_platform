package com.fandou.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.dto.RegisterDto;
import com.fandou.entity.User;
import com.fandou.mapper.UserMapper;
import com.fandou.service.UserService;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.fandou.dto.UserUpdateDto;

import java.util.Date;

// 提供了自定义的用户服务，也为Spring Security提供了加载用户的能力。

@Service
public class UserServiceImpl implements UserService, UserDetailsService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserServiceImpl(UserMapper userMapper, PasswordEncoder passwordEncoder) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }

    // 实现UserService接口

    @Override
    public User findByUsername(String username) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        return userMapper.selectOne(queryWrapper);
    }
    @Override
    public User registerNewUser(RegisterDto registerDto) {
        if (findByUsername(registerDto.getUsername()) != null) {
            throw new RuntimeException("用户名已存在!");
        }

        User newUser = new User();
        newUser.setUsername(registerDto.getUsername());
        // 对密码进行BCrypt加密
        newUser.setPassword(passwordEncoder.encode(registerDto.getPassword()));
        newUser.setRole(registerDto.getRole());
        newUser.setCreateTime(new Date());

        // 将新用户插入数据库
        userMapper.insert(newUser);
        return newUser;
    }

    // admin查询用户列表
    @Override
    public PageResult<User> getAllUsers(int pageNum, int pageSize){
        Page<User> page = new Page<>(pageNum, pageSize);
        QueryWrapper<User> Wrapper = new QueryWrapper<>();
        userMapper.selectPage(page, Wrapper);
        return new PageResult<>(page.getTotal(), page.getRecords());
    }


    // admin根据用户名删除用户
    @Override
    public boolean deletebyUsername(String username){
        User user = findByUsername(username);
        if (user == null){
            return false;
        }
        QueryWrapper<User> Wrapper = new QueryWrapper<>();
        Wrapper.eq("username",username);
        int result = userMapper.delete(Wrapper);
        return result == 1;//删除成功
    };

    // admin修改用户信息
    @Override
    public User updateUserInfo(String originalUsername, UserUpdateDto updateDto){
        User user = findByUsername(originalUsername);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        // 防止用户名重叠
        if (updateDto.getUsername() != null && !updateDto.getUsername().equals(originalUsername)) {
            User existingUser = findByUsername(updateDto.getUsername());
            if (existingUser != null) {
                throw new RuntimeException("用户名已被使用,请重新输入");
            }
        }
        UpdateWrapper<User> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("username", originalUsername);
        if(updateDto.getUsername() != null){
            updateWrapper.set("username", updateDto.getUsername());
        }
        if (updateDto.getPassword() != null && !updateDto.getPassword().isEmpty()) {
            // 对新密码进行加密
            String encodedPassword = passwordEncoder.encode(updateDto.getPassword());
            updateWrapper.set("password", encodedPassword);
        }
        if (updateDto.getAvatar() != null && !updateDto.getAvatar().isEmpty()) {
            // 更改头像
            updateWrapper.set("avatar", updateDto.getAvatar());
        }
        int updated = userMapper.update(null, updateWrapper);
        if (updated <= 0){
            throw new RuntimeException("更新用户信息失败");
        }
    return  findByUsername(updateDto.getUsername() != null ? updateDto.getUsername() : originalUsername);
    };

    // 实现Spring Security的UserDetailsService接口
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 直接复用自己写的findByUsername方法
        User user = findByUsername(username);

        // 如果找不到用户，必须抛出这个异常，Spring Security会捕获它并认为是认证失败
        if (user == null) {
            throw new UsernameNotFoundException("用户 '" + username + "' 不存在.");
        }

        // 将我们自己的User对象，转换成Spring Security能识别的UserDetails对象
        // 我们在这里把数据库中存储的角色字符串 (如 'admin')，变成了Security认识的权限 ('ROLE_admin')
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_" + user.getRole())
        );
    }

    @Override
    public User getCurrentUser() {
        // 从Security core中获取当前的认证信息
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 检查认证信息是否存在，以及用户是否是“匿名”的
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            // 在演示项目中，如果获取不到可以返回null
            // 在正式项目中，通常会抛出一个自定义的“未登录”异常
            return null;
        }

        // 获取用户的主要身份信息 (Principal)
        Object principal = authentication.getPrincipal();

        String username;
        // 判断身份信息的类型
        if (principal instanceof UserDetails) {
            // 如果是UserDetails类型，可以直接获取用户名
            username = ((UserDetails) principal).getUsername();
        } else {
            // 否则，直接将其转换为字符串（通常就是用户名）
            username = principal.toString();
        }

        // 用获取到的用户名，去数据库查询完整的User实体对象
        // 因为SecurityContextHolder里通常只存了用户名、密码(已擦除)和权限，
        // 而我们需要的是包含所有完整信息的User对象。
        return this.findByUsername(username);
    }

}