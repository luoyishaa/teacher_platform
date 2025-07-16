package com.fandou.service;

import com.fandou.entity.OperationLog;
import com.fandou.entity.Resource;
import com.fandou.vo.PageResult;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ResourceService {
    /**
     * 上传文件并将其保存为个人资源
     * @param file 上传的文件
     * @return 创建好的Resource实体
     * @throws Exception 文件上传异常
     */
    Resource createResource(MultipartFile file) throws Exception;

    /**
     * 获取当前登录用户的个人资源列表
     * @return 资源列表
     */
    PageResult<Resource> listMyResources(int pageNum, int pageSize);

    /**
     * 删除一个资源
     * @param resourceId 资源ID
     * @return 是否删除成功
     */
    boolean deleteResource(Long resourceId);
}
