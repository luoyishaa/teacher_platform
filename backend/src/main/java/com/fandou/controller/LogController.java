package com.fandou.controller;

import com.fandou.entity.OperationLog;
import com.fandou.service.LogService;
import com.fandou.vo.ApiResponse;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/logs")
public class LogController {

    @Autowired
    private LogService logService;

    /**
     * 分页查询操作日志，支持按用户名模糊筛选。
     * 这里是读接口，不挂 @Log 注解：否则每翻一页都会往审计表里再写一条记录，导致日志自我膨胀。
     */
    @GetMapping("")
    @PreAuthorize("hasAuthority('ROLE_admin')")
    public ApiResponse<PageResult<OperationLog>> getLogs(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String username) {

        PageResult<OperationLog> result = logService.listLogs(pageNum, pageSize, username);
        return ApiResponse.success(result);
    }
}