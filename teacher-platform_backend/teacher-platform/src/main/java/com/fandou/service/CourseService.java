package com.fandou.service;
import com.fandou.dto.DeleteCourseDto;
import com.fandou.dto.NewCourseDto;
import com.fandou.dto.UpdateCourseDto;
import com.fandou.entity.Course;
import com.fandou.vo.PageResult;
import org.springframework.stereotype.Service;
import java.util.List;
@Service

public interface CourseService {

    List<Course> findcourseByusername(String username);
    Course createnewcourse(NewCourseDto newCourseDto,String username);
    Course deletecourse(DeleteCourseDto deleteCourseDto);
    Course updateCourse(UpdateCourseDto updateCourseDto, String username);
    PageResult<Course> listCoursesByCurrentUser(int pageNum, int pageSize);
}
