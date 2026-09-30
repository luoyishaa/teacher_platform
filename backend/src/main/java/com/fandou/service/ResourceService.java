package com.fandou.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.entity.Resource;
import com.fandou.exception.BusinessException;
import com.fandou.mapper.ResourceMapper;
import com.fandou.storage.FileStorage;
import com.fandou.vo.PageResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.Date;

@Service
public class ResourceService {
    private static final Logger log = LoggerFactory.getLogger(ResourceService.class);
    private final ResourceMapper resources;
    private final UserService users;
    private final FileStorage storage;
    private final WorkspaceService workspace;

    public ResourceService(ResourceMapper resources, UserService users, FileStorage storage, WorkspaceService workspace) {
        this.resources = resources;
        this.users = users;
        this.storage = storage;
        this.workspace = workspace;
    }

    private String owner() {
        var user = users.getCurrentUser();
        if (user == null || !"teacher".equals(user.getRole())) throw new BusinessException(403, "仅教师可以管理资料");
        return user.getUsername();
    }

    public PageResult<Resource> listMyResources(int pageNum, int pageSize) {
        String username = owner();
        if (pageNum < 1 || pageSize < 1 || pageSize > 100) throw new BusinessException(400, "分页参数不合法");
        Page<Resource> page = new Page<>(pageNum, pageSize);
        resources.selectPage(page, new LambdaQueryWrapper<Resource>()
                .eq(Resource::getUploaderName, username).orderByDesc(Resource::getCreateTime));
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    public Resource requireOwned(Long id) {
        Resource resource = resources.selectById(id);
        if (resource == null) throw new BusinessException(404, "资料不存在");
        if (!owner().equals(resource.getUploaderName())) throw new BusinessException(403, "无权访问这份资料");
        return resource;
    }

    public Resource createResource(MultipartFile file) throws IOException {
        String username = owner();
        if (file.isEmpty()) throw new BusinessException(400, "请选择非空文件");
        String name = file.getOriginalFilename();
        if (name == null || name.isBlank()) throw new BusinessException(400, "文件名不能为空");
        name = name.replace('\\', '/');
        name = name.substring(name.lastIndexOf('/') + 1);
        if (name.length() > 255) throw new BusinessException(400, "文件名过长");
        String key = storage.save(file);
        try {
            Resource resource = new Resource();
            resource.setResourceName(name);
            resource.setUploaderName(username);
            resource.setStorageKey(key);
            resource.setContentType(file.getContentType() == null ? "application/octet-stream" : file.getContentType());
            resource.setSizeBytes(file.getSize());
            resource.setCreateTime(new Date());
            resources.insert(resource);
            return resource;
        } catch (RuntimeException error) {
            try { storage.delete(key); } catch (IOException cleanupError) { error.addSuppressed(cleanupError); }
            throw error;
        }
    }

    public byte[] read(Long id) throws IOException {
        Resource resource = requireOwned(id);
        if (resource.getStorageKey() == null) throw new BusinessException(409, "旧版资料需要重新上传");
        try (InputStream input = storage.open(resource.getStorageKey())) { return input.readAllBytes(); }
    }

    @Transactional
    public void deleteResource(Long id) {
        Resource resource = requireOwned(id);
        if (workspace.isAttached(id)) throw new BusinessException(409, "资料已用于章节，请先移除引用");
        resources.deleteById(id);
        if (resource.getStorageKey() != null) {
            String key = resource.getStorageKey();
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override public void afterCommit() {
                    try { storage.delete(key); }
                    catch (IOException error) { log.error("Resource object cleanup failed: {}", key, error); }
                }
            });
        }
    }
}
