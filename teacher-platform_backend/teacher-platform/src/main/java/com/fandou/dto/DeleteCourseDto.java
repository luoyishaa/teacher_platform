package com.fandou.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;

@Data
public class DeleteCourseDto {
    @NotEmpty(message = "课程ID不能为空")
    private Integer courseId;
}

