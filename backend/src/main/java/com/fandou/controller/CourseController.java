package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.dto.DeleteCourseDto;
import com.fandou.dto.NewCourseDto;
import com.fandou.dto.UpdateCourseDto;
import com.fandou.entity.Course;
import com.fandou.exception.BusinessException;
import com.fandou.service.CourseService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/courses")
@PreAuthorize("hasAuthority('ROLE_teacher')")
public class CourseController {
    private final CourseService courses;
    public CourseController(CourseService courses) { this.courses = courses; }

    private String username() { return SecurityContextHolder.getContext().getAuthentication().getName(); }

    @GetMapping
    public ApiResponse<PageResult<Course>> list(@RequestParam(defaultValue = "1") int pageNum,
                 @RequestParam(defaultValue = "10") int pageSize) {
        if (pageNum < 1 || pageSize < 1 || pageSize > 100) throw new BusinessException(400, "分页参数不合法");
        return ApiResponse.success(courses.listCoursesByCurrentUser(pageNum, pageSize));
    }

    @PostMapping
    @Log(description = "课程创建")
    public ApiResponse<Course> create(@Valid @RequestBody NewCourseDto dto) {
        return ApiResponse.success(courses.createnewcourse(dto, username()));
    }

    @PutMapping("/{courseId}")
    @Log(description = "课程修改")
    public ApiResponse<Course> update(@PathVariable int courseId, @RequestBody UpdateCourseDto dto) {
        dto.setCourseId(courseId);
        return ApiResponse.success(courses.updateCourse(dto, username()));
    }

    @DeleteMapping("/{courseId}")
    @Log(description = "课程删除")
    public ApiResponse<Void> delete(@PathVariable int courseId) {
        DeleteCourseDto dto = new DeleteCourseDto();
        dto.setCourseId(courseId);
        courses.deletecourse(dto, username());
        return ApiResponse.success("课程已删除");
    }
}
