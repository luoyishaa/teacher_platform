package com.fandou.dto;

import jakarta.validation.constraints.NotEmpty;

public class ChapterListDto {
    @NotEmpty(message = "课程名不能为空")
    private String course_name;
}