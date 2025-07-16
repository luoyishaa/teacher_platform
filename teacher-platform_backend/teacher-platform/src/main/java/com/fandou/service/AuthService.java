package com.fandou.service;

import com.fandou.vo.LoginVo;

public interface AuthService {
//    User register(RegisterDto registerDto);
    LoginVo login(String username, String password);
}

