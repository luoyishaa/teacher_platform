package com.fandou.service;

import com.fandou.entity.OperationLog;
import com.fandou.vo.PageResult;

public interface LogService {

    void saveLog(OperationLog log);

    PageResult<OperationLog> listLogs(int pageNum,int pageSize,String username);

}
