package com.fandou.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fandou.entity.OperationLog;
import com.fandou.vo.PageResult;
import org.apache.ibatis.annotations.Mapper;

import java.lang.reflect.ParameterizedType;

@Mapper
public interface OperationLogMapper extends BaseMapper<OperationLog> {

    void saveLog(OperationLog log);

    PageResult<OperationLog> listLogs(int pageNum, int pageSize, String username);
}
