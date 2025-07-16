package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.entity.Resource;
import com.fandou.service.ResourceService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/resources")
@PreAuthorize("hasAuthority('ROLE_teacher')")
public class ResourceController {

    private final ResourceService resourceService;

    @Autowired
    public ResourceController(ResourceService resourceService) {
        this.resourceService = resourceService;
    }

    /**
     * 上传新资源到个人资源库
     */
    @PostMapping
    @Log(description = "上传个人资源")
    public ApiResponse<Resource> createResource(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ApiResponse.error(40001, "上传的文件不能为空");
        }
        try {
            Resource createdResource = resourceService.createResource(file);
            return ApiResponse.success("资源上传成功", createdResource);
        } catch (Exception e) {
            e.printStackTrace();
            return ApiResponse.error(50001, "资源上传失败: " + e.getMessage());
        }
    }

    /**
     * 获取我的资源列表
     */
    @GetMapping
    public ApiResponse<PageResult<Resource>> getMyResources(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {

        PageResult<Resource> result = resourceService.listMyResources(pageNum, pageSize);
        return ApiResponse.success(result);
    }

    /**
     * 删除我的某个资源
     */
    @DeleteMapping("/{id}")
    @Log(description = "删除个人资源")
    public ApiResponse<Void> deleteResource(@PathVariable("id") Long resourceId) {
        boolean success = resourceService.deleteResource(resourceId);
        if (success) {
            return ApiResponse.success("资源删除成功");
        } else {
            return ApiResponse.error(40301, "无权删除或资源不存在");
        }
    }
}