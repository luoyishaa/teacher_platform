package com.fandou.dto;

import lombok.Data;

@Data
public class UserUpdateDto {
    private String username;
    private String password;
    private String avatar;
}
