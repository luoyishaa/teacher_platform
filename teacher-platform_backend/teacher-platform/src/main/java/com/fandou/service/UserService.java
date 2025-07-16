package com.fandou.service;

import com.fandou.dto.RegisterDto;
import com.fandou.entity.User;
import com.fandou.dto.UserUpdateDto;
import com.fandou.vo.PageResult;

public interface UserService {

    User findByUsername(String username);

    User registerNewUser(RegisterDto registerDto);

    PageResult<User> getAllUsers(int pageNum, int pageSize);

    boolean deletebyUsername(String username);

    User updateUserInfo(String originalUsername, UserUpdateDto updateDto);

    User getCurrentUser();
}
