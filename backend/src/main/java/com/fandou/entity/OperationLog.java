package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
@TableName("operation_log")
public class OperationLog {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private String username;
    private String description;
    private String method;
    private String ip;
    private Date createTime;
}
