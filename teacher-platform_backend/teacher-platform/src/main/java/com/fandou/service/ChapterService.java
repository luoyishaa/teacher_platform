package com.fandou.service;

import com.fandou.dto.NewChapterDto;
import com.fandou.entity.Chapter;
import com.fandou.vo.PageResult;

import java.util.List;

public interface ChapterService {
    Chapter addChapter(Integer courseId, NewChapterDto dto);

    Chapter updateChapter(Integer courseId, Integer chapterId, NewChapterDto dto);
    boolean deleteChapter(Integer courseId, Integer chapterId);
    PageResult<Chapter> listChaptersByCourseId(Integer courseId, int pageNum, int pageSize);
}
