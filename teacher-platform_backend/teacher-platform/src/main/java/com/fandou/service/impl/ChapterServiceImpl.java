package com.fandou.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.dto.NewChapterDto;
import com.fandou.entity.Chapter;
import com.fandou.mapper.ChapterMapper;
import com.fandou.service.ChapterService;
import com.fandou.vo.PageResult;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class ChapterServiceImpl implements ChapterService {

    private final ChapterMapper chapterMapper;

    public ChapterServiceImpl(ChapterMapper chapterMapper) {
        this.chapterMapper = chapterMapper;
    }




    @Override
    public Chapter addChapter(Integer courseId, NewChapterDto dto) {
        Chapter chapter = new Chapter();
        chapter.setCourseId(courseId);  // 强制绑定路径中的 courseId
        chapter.setChapterName(dto.getChapterName());
        chapter.setDescription(dto.getDescription());
        chapter.setVideo(dto.getVideo());
        chapter.setPpt(dto.getPpt());

        chapterMapper.insert(chapter);
        return chapter;
    }


    @Override
    public Chapter updateChapter(Integer courseId, Integer chapterId, NewChapterDto dto) {
        Chapter chapter = chapterMapper.selectById(chapterId);
        if (chapter == null || !chapter.getCourseId().equals(courseId)) {
            throw new IllegalArgumentException("章节不属于该课程或不存在");
        }
        chapter.setChapterName(dto.getChapterName());
        chapter.setDescription(dto.getDescription());
        chapter.setVideo(dto.getVideo());
        chapter.setPpt(dto.getPpt());
        chapterMapper.updateById(chapter);
        return chapter;
    }

    @Override
    public boolean deleteChapter(Integer courseId, Integer chapterId) {
        Chapter chapter = chapterMapper.selectById(chapterId);
        if (chapter == null || !chapter.getCourseId().equals(courseId)) {
            throw new IllegalArgumentException("章节不属于该课程或不存在");
        }
        return chapterMapper.deleteById(chapterId) > 0;
    }
    @Override
    public PageResult<Chapter> listChaptersByCourseId(Integer courseId, int pageNum, int pageSize) {
        if (courseId == null) {
            return new PageResult<>(0L, Collections.emptyList());
        }

        Page<Chapter> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Chapter> wrapper = new QueryWrapper<>();
        wrapper.eq("course_id", courseId).orderByDesc("create_time");

        chapterMapper.selectPage(page, wrapper);

        return new PageResult<>(page.getTotal(), page.getRecords());
    }
}