package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

/**
 * 课程实体类
 * 关联关系：一个老师（teacher）可以创建多个课程
 */
@Data
@TableName("course")
@AllArgsConstructor
@NoArgsConstructor
public class Course implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "course_id", type = IdType.AUTO)
    private Integer courseId;          // 课程ID（主键）
    @TableField("course_name")
    private String courseName;        // 课程名称
    private String description;       // 课程描述
    @TableField(value="create_time",fill = FieldFill.INSERT) // 插入时自动填充
    private Date createTime;          // 创建时间
    @TableField(value="update_time",fill = FieldFill.INSERT_UPDATE) // 插入时自动填充
    private Date updateTime;
    private String username;           // 关联的用户名（user.id，role=teacher）
    @TableField("course_coverimage")
    private String courseImg;
}