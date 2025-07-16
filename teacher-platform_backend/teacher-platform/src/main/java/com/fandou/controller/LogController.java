package com.fandou.controller;

import com.fandou.aop.Log;
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

    @GetMapping("")
    @Log(description = "上传文件")
    @PreAuthorize("hasAuthority('ROLE_admin')")
    public ApiResponse<PageResult<OperationLog>> getLogs(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String username) {

        PageResult<OperationLog> result = logService.listLogs(pageNum, pageSize, username);
        return ApiResponse.success(result);
    }
}