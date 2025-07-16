package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.dto.NewChapterDto;
import com.fandou.entity.Chapter;
import com.fandou.service.ChapterService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/courses/{courseId}/chapters")
public class ChapterController {

    private final ChapterService chapterService;

    public ChapterController(ChapterService chapterService) {
        this.chapterService = chapterService;
    }

    /**
     * ✅ 分页获取章节
     */
    @GetMapping
    public ApiResponse<PageResult<Chapter>> getChaptersByCourseId(
            @PathVariable Integer courseId,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {

        PageResult<Chapter> result = chapterService.listChaptersByCourseId(courseId, pageNum, pageSize);
        return ApiResponse.success("章节获取成功", result);
    }

    @PostMapping
    @Log(description = "添加章节")
    public ApiResponse<Chapter> addChapter(@PathVariable Integer courseId, @RequestBody NewChapterDto dto) {
        Chapter chapter = chapterService.addChapter(courseId, dto);
        return ApiResponse.success("章节添加成功", chapter);
    }

    @PutMapping("/{chapterId}")
    @Log(description = "更新章节")
    public ApiResponse<Chapter> updateChapter(@PathVariable Integer courseId,
                                              @PathVariable Integer chapterId,
                                              @RequestBody NewChapterDto dto) {
        try {
            Chapter updated = chapterService.updateChapter(courseId, chapterId, dto);
            return ApiResponse.success("章节更新成功", updated);
        } catch (IllegalArgumentException e) {
            return ApiResponse.error(404, e.getMessage());
        } catch (Exception e) {
            return ApiResponse.error(500, "章节更新失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{chapterId}")
    @Log(description = "删除章节")
    public ApiResponse<?> deleteChapter(@PathVariable Integer courseId,
                                        @PathVariable Integer chapterId) {
        try {
            boolean result = chapterService.deleteChapter(courseId, chapterId);
            if (result) {
                return ApiResponse.success("章节删除成功");
            } else {
                return ApiResponse.error(404, "章节不存在或不属于该课程");
            }
        } catch (IllegalArgumentException e) {
            return ApiResponse.error(404, e.getMessage());
        } catch (Exception e) {
            return ApiResponse.error(500, "章节删除失败: " + e.getMessage());
        }
    }
}
