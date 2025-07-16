package com.fandou.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;
@Data
public class NewChapterDto {
    private String chapterName;
    private String description;
    private String video;
    private String ppt;
}

