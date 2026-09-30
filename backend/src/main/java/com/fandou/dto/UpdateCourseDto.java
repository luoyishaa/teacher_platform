package com.fandou.dto;

import lombok.Data;

@Data
public class UpdateCourseDto {
    private Integer courseId;
    private String courseName;
    private String description;
    private String courseImg;
}