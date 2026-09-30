package com.fandou.dto;

import lombok.Data;

import jakarta.validation.constraints.NotEmpty;

@Data

public class NewCourseDto {
    @NotEmpty(message = "课程名不能为空")
    private String courseName;
    private String description;
    private String courseImg;
}

