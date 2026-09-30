package com.fandou.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;
@Data
public class NewChapterDto {
    @NotBlank(message = "章节名不能为空")
    private String chapterName;
    private String description;
    private String video;
    private String ppt;
}

