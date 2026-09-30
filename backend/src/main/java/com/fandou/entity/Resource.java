package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.Date;

@Data
@TableName("resource")
public class Resource {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    @JsonIgnore
    private String fileUrl;
    private Date createTime;
    private String uploaderName;
    private String resourceName;
    @JsonIgnore
    private String storageKey;
    private String contentType;
    private Long sizeBytes;
}
