package com.fandou.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;

@Data

public class NewCourseDto {
    @NotEmpty(message = "课程名不能为空")
    private String courseName;
    @NotEmpty(message = "课程描述不能为空")
    private String description;
    @NotEmpty(message = "课程封面不能为空")
    private String courseImg;
}

