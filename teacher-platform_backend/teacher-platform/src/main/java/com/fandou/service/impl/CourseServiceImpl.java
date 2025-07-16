package com.fandou.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.dto.DeleteCourseDto;
import com.fandou.dto.NewCourseDto;
import com.fandou.dto.UpdateCourseDto;
import com.fandou.entity.Chapter;
import com.fandou.entity.Course;
import com.fandou.mapper.ChapterMapper;
import com.fandou.mapper.CourseMapper;
import com.fandou.mapper.UserMapper;
import com.fandou.service.CourseService;
import com.fandou.service.UserService;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fandou.entity.User;
import java.util.Collections;
import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {
    private final CourseMapper courseMapper;
    private final UserMapper userMapper;
    private final ChapterMapper chapterMapper;
    @Autowired
    private UserService userService;
    public CourseServiceImpl(CourseMapper courseMapper,UserMapper userMapper,ChapterMapper chapterMapper) {
        this.courseMapper = courseMapper;
        this.userMapper = userMapper;
        this.chapterMapper = chapterMapper;
    }

    // 1. 根据 username 查询课程列表
    @Override
    public List<Course> findcourseByusername(String username) {
        QueryWrapper<Course> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username); // 直接用username字段
        return courseMapper.selectList(wrapper);
    }

    // 2. 创建新课程mysql
    @Override
    public Course createnewcourse(NewCourseDto newCourseDto, String username) {
        // 使用 QueryWrapper 按 username 字段查询用户
        User user = userMapper.selectOne(new QueryWrapper<User>().eq("username", username));
        if (user == null) {
            throw new IllegalArgumentException("用户不存在，无法创建课程");
        }

        Course course = new Course();
        course.setCourseName(newCourseDto.getCourseName());
        course.setDescription(newCourseDto.getDescription());
        course.setUsername(username);  // 绑定用户名
        course.setCourseImg(newCourseDto.getCourseImg());
        courseMapper.insert(course);
        return course;
    }



    // 3. 删除课程
    @Override
    public Course deletecourse(DeleteCourseDto deleteCourseDto) {
        Integer courseId = deleteCourseDto.getCourseId();
        Course course = courseMapper.selectById(courseId);
        if (course != null) {
            // 先删章节
            QueryWrapper<Chapter> chapterWrapper = new QueryWrapper<>();
            chapterWrapper.eq("course_id", courseId);
            chapterMapper.delete(chapterWrapper); // 注意需要注入 chapterMapper

            // 再删课程
            courseMapper.deleteById(courseId);
        }
        return course;
    }


    @Override
    public Course updateCourse(UpdateCourseDto updateCourseDto, String username) {
        // 先根据ID查询课程
        Course course = courseMapper.selectById(updateCourseDto.getCourseId());
        if (course == null) {
            throw new IllegalArgumentException("课程不存在，无法更新");
        }
        // 你可以校验当前用户是否有权限更新，比如判断username是否匹配
        if (!course.getUsername().equals(username)) {
            throw new SecurityException("无权修改他人课程");
        }
        // 更新字段（非空的才更新，避免覆盖）
        if (updateCourseDto.getCourseName() != null) {
            course.setCourseName(updateCourseDto.getCourseName());
        }
        if (updateCourseDto.getDescription() != null) {
            course.setDescription(updateCourseDto.getDescription());
        }
        if (updateCourseDto.getCourseImg() != null) {
            course.setCourseImg(updateCourseDto.getCourseImg());
        }
        courseMapper.updateById(course);
        return course;
    }
    @Override
    public PageResult<Course> listCoursesByCurrentUser(int pageNum, int pageSize) {
        User currentUser = userService.getCurrentUser();
        if (currentUser == null) {
            return new PageResult<>(0L, Collections.emptyList());
        }

        Page<Course> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Course> wrapper = new QueryWrapper<>();
        wrapper.eq("username", currentUser.getUsername());
        wrapper.orderByDesc("create_time"); // 你也可以按id排序

        courseMapper.selectPage(page, wrapper);

        return new PageResult<>(page.getTotal(), page.getRecords());
    }


}
