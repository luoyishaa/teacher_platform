package com.fandou.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.dto.NewChapterDto;
import com.fandou.entity.Chapter;
import com.fandou.entity.Course;
import com.fandou.entity.Resource;
import com.fandou.exception.BusinessException;
import com.fandou.mapper.ChapterMapper;
import com.fandou.mapper.ChapterResourceMapper;
import com.fandou.mapper.CourseMapper;
import com.fandou.mapper.ResourceMapper;
import com.fandou.vo.AttachedResourceRow;
import com.fandou.vo.ChapterView;
import com.fandou.vo.PageResult;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import java.util.Map;

@Service
public class WorkspaceService {
    private final CourseMapper courses;
    private final ChapterMapper chapters;
    private final ResourceMapper resources;
    private final ChapterResourceMapper links;
    private final UserService users;

    public WorkspaceService(CourseMapper courses, ChapterMapper chapters, ResourceMapper resources,
                            ChapterResourceMapper links, UserService users) {
        this.courses = courses; this.chapters = chapters; this.resources = resources;
        this.links = links; this.users = users;
    }

    private String username() {
        var user = users.getCurrentUser();
        if (user == null || !"teacher".equals(user.getRole())) throw new BusinessException(403, "仅教师可以管理课程");
        return user.getUsername();
    }

    private void requireOwnedCourse(int courseId) {
        Course course = courses.selectById(courseId);
        if (course == null) throw new BusinessException(404, "课程不存在");
        if (!username().equals(course.getUsername())) throw new BusinessException(403, "无权访问这门课程");
    }

    private Chapter requireChapter(int courseId, int chapterId) {
        requireOwnedCourse(courseId);
        Chapter chapter = chapters.selectById(chapterId);
        if (chapter == null || !courseIdEquals(chapter, courseId)) throw new BusinessException(404, "章节不存在");
        return chapter;
    }

    private boolean courseIdEquals(Chapter chapter, int courseId) {
        return chapter.getCourseId() != null && chapter.getCourseId() == courseId;
    }

    public PageResult<ChapterView> list(int courseId, int pageNum, int pageSize) {
        requireOwnedCourse(courseId);
        if (pageNum < 1 || pageSize < 1 || pageSize > 100) throw new BusinessException(400, "分页参数不合法");
        Page<Chapter> page = new Page<>(pageNum, pageSize);
        chapters.selectPage(page, new LambdaQueryWrapper<Chapter>()
                .eq(Chapter::getCourseId, courseId).orderByAsc(Chapter::getCreateTime, Chapter::getChapterId));
        Map<Integer, ChapterView> byId = new HashMap<>();
        var views = page.getRecords().stream().map(chapter -> {
            ChapterView view = new ChapterView(chapter);
            byId.put(view.getChapterId(), view);
            return view;
        }).toList();
        for (AttachedResourceRow row : links.listForCourse(courseId)) {
            ChapterView view = byId.get(row.getChapterId());
            if (view != null) view.getResources().add(row);
        }
        return new PageResult<>(page.getTotal(), views);
    }

    @Transactional
    public Chapter create(int courseId, NewChapterDto dto) {
        requireOwnedCourse(courseId);
        Chapter chapter = new Chapter();
        chapter.setCourseId(courseId);
        chapter.setChapterName(dto.getChapterName().trim());
        chapter.setDescription(dto.getDescription());
        chapters.insert(chapter);
        return chapter;
    }

    @Transactional
    public Chapter update(int courseId, int chapterId, NewChapterDto dto) {
        Chapter chapter = requireChapter(courseId, chapterId);
        chapter.setChapterName(dto.getChapterName().trim());
        chapter.setDescription(dto.getDescription());
        chapters.updateById(chapter);
        return chapter;
    }

    @Transactional
    public void delete(int courseId, int chapterId) {
        requireChapter(courseId, chapterId);
        chapters.deleteById(chapterId);
    }

    @Transactional
    public void attach(int courseId, int chapterId, long resourceId) {
        requireChapter(courseId, chapterId);
        Resource resource = resources.selectById(resourceId);
        if (resource == null) throw new BusinessException(404, "资料不存在");
        if (!username().equals(resource.getUploaderName())) throw new BusinessException(403, "只能使用自己的资料");
        if (links.countPair(chapterId, resourceId) > 0) throw new BusinessException(409, "资料已经在此章节");
        links.attach(chapterId, resourceId);
    }

    @Transactional
    public void detach(int courseId, int chapterId, long resourceId) {
        requireChapter(courseId, chapterId);
        if (links.detach(chapterId, resourceId) == 0) throw new BusinessException(404, "章节中没有这份资料");
    }

    public boolean isAttached(long resourceId) { return links.countByResource(resourceId) > 0; }
}
