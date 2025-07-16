package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("resource")
public class Resource {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private String fileUrl;
    private Date createTime;
    private String uploaderName;
    private String resourceName;
}
