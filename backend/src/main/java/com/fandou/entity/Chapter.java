// --- Chapter.java 实体类 ---
package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@TableName("chapter")
@AllArgsConstructor
@NoArgsConstructor
public class Chapter implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "chapter_id", type = IdType.AUTO)
    private Integer chapterId;
    private Integer courseId;
    private String chapterName;
    private String description;
    // 与 course、operation_log 保持一致，使用 Date 对应库里的 datetime，
    // 并由 MyMetaObjectHandler 在插入时自动填充（之前用 String 且无人赋值，导致该字段一直为空，
    // 而章节列表又按 create_time 倒序排序，排序结果不可靠）
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;
    private String video;
    private String ppt;
}