package com.fandou.vo;

import lombok.Data;
@Data
public class UserInfoVo {

    private Long id;
    private String username;
    private String role;
    private String avatar;// 头像对应的url

}
