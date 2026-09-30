package com.fandou.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//返回前端初始化主界面所需的所有基本信息，如用户ID、用户名、角色、头像等，避免前端在登录后立即发起另一次请求来获取用户信息

@Data
@NoArgsConstructor      // Lombok: 生成一个无参构造函数
@AllArgsConstructor     // Lombok: 生成一个包含所有参数的构造函数
public class LoginVo {

    /**
     * JSON Web Token (JWT)
     * 这是用户后续所有请求的身份凭证。前端需要妥善保管。
     */
    private String token;

    /**
     * 用户的基本信息
     * 嵌套了一个UserInfoVo对象，使结构更清晰。
     */
    private UserInfoVo userInfo;
}
