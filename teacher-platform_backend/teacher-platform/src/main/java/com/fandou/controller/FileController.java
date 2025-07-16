package com.fandou.controller;

import com.fandou.aop.Log;
import com.fandou.service.OssService;
import com.fandou.vo.ApiResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/files")
public class FileController {
    private final OssService ossService;

    public FileController(OssService ossService){
        this.ossService=ossService;
    }

    @PostMapping("/upload")
    @Log(description="上传文件")
    //@PreAuthorize("hasAuthority('ROLE_teacher')")//如果不限定就是任何登录后的人都能进
    public ApiResponse<String> uploadFile(@RequestParam("file") MultipartFile file){
        if(file.isEmpty()){
            return ApiResponse.error(40001,"上传的文件不能为空");
        }

        try{
            String fileUrl= ossService.uploadFile(file);

            return ApiResponse.success(fileUrl);
        }catch(Exception e){
            e.printStackTrace();

            return ApiResponse.error(50001,"上传文件失败，请联系管理员");

        }
    }

}
