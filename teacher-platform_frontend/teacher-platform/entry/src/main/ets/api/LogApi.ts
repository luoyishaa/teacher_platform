// LogApi.ts
import { BaseApi } from './BaseApi';
import http from '@ohos.net.http';
import { ApiResponse } from '../types/api';

// 定义日志记录类型
interface LogRecord {
  id: number;
  username: string;
  description: string;
  method: string;
  ip: string;
  createTime: string;
}

// 定义分页响应类型
interface LogPageResult {
  records: LogRecord[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

class LogApi extends BaseApi {
  /**
   * 获取操作日志列表 (分页)
   * @param pageNum 页码，默认为1
   * @param pageSize 每页条数，默认为10
   */
  async getOperationLogs(
    pageNum: number = 1,
    pageSize: number = 50
  ): Promise<ApiResponse<LogPageResult>> {
    return this.request(`/logs?pageNum=${pageNum}&pageSize=${pageSize}`, {
      method: http.RequestMethod.GET
    });
  }

  /**
   * 按用户ID查询操作日志
   * @param userId 用户ID
   * @param pageNum 页码
   * @param pageSize 每页条数
   */
  async getLogsByUser(
    userId: number,
    pageNum: number = 1,
    pageSize: number = 10
  ): Promise<ApiResponse<LogPageResult>> {
    return this.request(
      `/logs/user/${userId}?pageNum=${pageNum}&pageSize=${pageSize}`,
      {
        method: http.RequestMethod.GET
      }
    );
  }
}

// 导出单例实例
export const logApi = new LogApi();
