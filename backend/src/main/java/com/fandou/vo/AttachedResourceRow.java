package com.fandou.vo;

import lombok.Data;
import java.util.Date;

@Data
public class AttachedResourceRow {
    private Integer chapterId;
    private Long id;
    private String resourceName;
    private Date createTime;
    private Long sizeBytes;
}
