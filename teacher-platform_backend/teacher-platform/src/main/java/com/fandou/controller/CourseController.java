package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.dto.DeleteCourseDto;
import com.fandou.dto.NewCourseDto;
import com.fandou.dto.UpdateCourseDto;
import com.fandou.entity.Course;
import com.fandou.service.CourseService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/courses")
public class CourseController {

    private final CourseService courseService;

    @Autowired
    public CourseController(CourseService courseService) {
        this.courseService = courseService;
    }

    // 1. 获取指定教师的课程列表
    @GetMapping
    public ApiResponse<PageResult<Course>> getCoursesByCurrentUser(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {

        PageResult<Course> pageResult = courseService.listCoursesByCurrentUser(pageNum, pageSize);
        return ApiResponse.success("课程列表获取成功", pageResult);
    }


    // 2. 创建新课程
    @PostMapping()
    @Log(description = "课程创建")
    public ApiResponse<Course> createCourse(@RequestBody NewCourseDto newCourseDto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUsername = authentication.getName();
        Course course = courseService.createnewcourse(newCourseDto, currentUsername);
        return ApiResponse.success("课程创建成功", course);
    }

    // 3. 删除课程
    @DeleteMapping("/{courseId}")
    @Log(description = "课程删除")
    public ApiResponse<Course> deleteCourse(@PathVariable Integer courseId) {
        try {
            DeleteCourseDto deleteCourseDto = new DeleteCourseDto();
            deleteCourseDto.setCourseId(courseId);
            Course deleted = courseService.deletecourse(deleteCourseDto);

            if (deleted != null) {
                return ApiResponse.success("删除成功", deleted);
            } else {
                // 当课程不存在时抛出异常
                throw new RuntimeException("课程不存在");
            }
        } catch (RuntimeException e) {
            // 捕获课程不存在异常
            return ApiResponse.error(404, e.getMessage());
        } catch (Exception e) {
            // 捕获其他意外异常
            return ApiResponse.error(500, "删除课程时发生错误: " + e.getMessage());
        }
    }

    // 4. 修改课程
    @PutMapping("/{courseId}")
    @Log(description = "课程修改")
    public ApiResponse<Course> updateCourse(@PathVariable Integer courseId, @RequestBody UpdateCourseDto updateCourseDto) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String currentUsername = authentication.getName();
            updateCourseDto.setCourseId(courseId);

            Course updated = courseService.updateCourse(updateCourseDto, currentUsername);

            if (updated != null) {
                return ApiResponse.success("课程更新成功", updated);
            } else {
                throw new RuntimeException("课程不存在");
            }
        } catch (RuntimeException e) {
            return ApiResponse.error(404, e.getMessage());
        } catch (Exception e) {
            return ApiResponse.error(500, "更新课程时发生错误: " + e.getMessage());
        }
    }

}
