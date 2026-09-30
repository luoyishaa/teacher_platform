package com.fandou.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fandou.entity.OperationLog;
import com.fandou.mapper.OperationLogMapper;
import com.fandou.service.LogService;
import com.fandou.vo.PageResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class LogServiceImpl implements LogService {
    @Autowired
    private OperationLogMapper operationLogMapper;
    @Override
    public void saveLog(OperationLog log){

        operationLogMapper.insert(log);
    }

    @Override
    public PageResult<OperationLog> listLogs(int pageNum, int pageSize, String username) {
        Page<OperationLog> page=new Page<>(pageNum,pageSize);
        // 按照用户名筛选
        QueryWrapper<OperationLog> queryWrapper = new QueryWrapper<>();
        if(StringUtils.hasText(username)){
            queryWrapper.like("username",username);
        }
        queryWrapper.orderByDesc("create_time");

        operationLogMapper.selectPage(page,queryWrapper);

        return new PageResult<>(page.getTotal(),page.getRecords());
    }
}
