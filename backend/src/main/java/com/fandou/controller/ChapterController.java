package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.dto.AttachResourceDto;
import com.fandou.dto.NewChapterDto;
import com.fandou.entity.Chapter;
import com.fandou.service.WorkspaceService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.ChapterView;
import com.fandou.vo.PageResult;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/courses/{courseId}/chapters")
@PreAuthorize("hasAuthority('ROLE_teacher')")
public class ChapterController {
    private final WorkspaceService workspace;
    public ChapterController(WorkspaceService workspace) { this.workspace = workspace; }

    @GetMapping
    public ApiResponse<PageResult<ChapterView>> list(@PathVariable int courseId,
                   @RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "10") int pageSize) {
        return ApiResponse.success(workspace.list(courseId, pageNum, pageSize));
    }

    @PostMapping
    @Log(description = "添加章节")
    public ApiResponse<Chapter> create(@PathVariable int courseId, @Valid @RequestBody NewChapterDto dto) {
        return ApiResponse.success(workspace.create(courseId, dto));
    }

    @PutMapping("/{chapterId}")
    @Log(description = "更新章节")
    public ApiResponse<Chapter> update(@PathVariable int courseId, @PathVariable int chapterId,
                                      @Valid @RequestBody NewChapterDto dto) {
        return ApiResponse.success(workspace.update(courseId, chapterId, dto));
    }

    @DeleteMapping("/{chapterId}")
    @Log(description = "删除章节")
    public ApiResponse<Void> delete(@PathVariable int courseId, @PathVariable int chapterId) {
        workspace.delete(courseId, chapterId); return ApiResponse.success("章节已删除");
    }

    @PostMapping("/{chapterId}/resources")
    @Log(description = "章节加入资料")
    public ApiResponse<Void> attach(@PathVariable int courseId, @PathVariable int chapterId,
                                    @Valid @RequestBody AttachResourceDto dto) {
        workspace.attach(courseId, chapterId, dto.getResourceId());
        return ApiResponse.success("资料已加入章节");
    }

    @DeleteMapping("/{chapterId}/resources/{resourceId}")
    @Log(description = "章节移除资料")
    public ApiResponse<Void> detach(@PathVariable int courseId, @PathVariable int chapterId,
                                    @PathVariable long resourceId) {
        workspace.detach(courseId, chapterId, resourceId);
        return ApiResponse.success("资料已从章节移除");
    }
}
