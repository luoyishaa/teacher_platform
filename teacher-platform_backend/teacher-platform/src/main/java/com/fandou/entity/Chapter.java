// --- Chapter.java 实体类 ---
package com.fandou.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

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
    @TableField(value="create_time")
    private String createTime;
    private String video;
    private String ppt;
}