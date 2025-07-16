package com.fandou.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.entity.Resource;
import com.fandou.entity.User;
import com.fandou.mapper.ResourceMapper;
import com.fandou.service.OssService;
import com.fandou.service.ResourceService;
import com.fandou.service.UserService;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class ResourceServiceImpl implements ResourceService {
    @Autowired
    private OssService ossService;
    @Autowired
    private ResourceMapper resourceMapper;
    @Autowired
    private UserService userService;

    @Override
    public Resource createResource(MultipartFile file)throws Exception{
        User currentUser=userService.getCurrentUser();
        if(currentUser==null){
            throw new RuntimeException("用户未登录，无法上传资源");
        }

        String fileUrl=ossService.uploadFile(file);
        Resource resource=new Resource();
        resource.setResourceName(file.getOriginalFilename());
        resource.setFileUrl(fileUrl);
        resource.setUploaderName(currentUser.getUsername());
        resource.setCreateTime(new Date());

        resourceMapper.insert(resource);
        return resource;
    }

    @Override
    public PageResult<Resource> listMyResources(int pageNum, int pageSize) {
        User currentUser = userService.getCurrentUser();
        if (currentUser == null) {
            return new PageResult<>(0L, Collections.emptyList());
        }

        // 分页
        Page<Resource> page = new Page<>(pageNum, pageSize);

        // 过滤
        QueryWrapper<Resource> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("uploader_name", currentUser.getUsername());
        queryWrapper.orderByDesc("create_time");

        resourceMapper.selectPage(page, queryWrapper);

        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    @Override
    public boolean deleteResource(Long resourceId) {
        User currentUser = userService.getCurrentUser();
        if (currentUser == null) {
            return false; // 未登录无法删除
        }

        // 检查要删除的资源是否属于当前用户
        Resource resource = resourceMapper.selectById(resourceId);
        if (resource == null || !resource.getUploaderName().equals(currentUser.getId())) {
            // 如果资源不存在，或者资源的上传者不是当前用户，则不允许删除
            System.out.println("资源不存在或无权限删除！");
            return false;
        }

        // TODO: 从OSS上删除物理文件
        // ossService.deleteFile(resource.getFileUrl());

        // 从数据库中删除记录
        int result = resourceMapper.deleteById(resourceId);
        return result > 0;
    }
}
