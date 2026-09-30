package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.entity.Resource;
import com.fandou.service.ResourceService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/resources")
@PreAuthorize("hasAuthority('ROLE_teacher')")
public class ResourceController {
    private final ResourceService resources;
    public ResourceController(ResourceService resources) { this.resources = resources; }

    @GetMapping
    public ApiResponse<PageResult<Resource>> list(@RequestParam(defaultValue = "1") int pageNum,
                                                    @RequestParam(defaultValue = "10") int pageSize) {
        return ApiResponse.success(resources.listMyResources(pageNum, pageSize));
    }

    @PostMapping
    @Log(description = "上传资料")
    public ApiResponse<Resource> upload(@RequestParam("file") MultipartFile file) throws IOException {
        return ApiResponse.success("资料上传成功", resources.createResource(file));
    }

    @GetMapping("/{id}/content")
    public ResponseEntity<byte[]> download(@PathVariable Long id) throws IOException {
        Resource resource = resources.requireOwned(id);
        byte[] bytes = resources.read(id);
        ContentDisposition disposition = ContentDisposition.attachment()
                .filename(resource.getResourceName(), StandardCharsets.UTF_8).build();
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, disposition.toString())
                .contentType(MediaType.APPLICATION_OCTET_STREAM).body(bytes);
    }

    @DeleteMapping("/{id}")
    @Log(description = "删除资料")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        resources.deleteResource(id);
        return ApiResponse.success("资料已删除");
    }
}
