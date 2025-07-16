import { BaseApi } from './BaseApi';
import { ApiResponse, Course, PageResult, UserInfo, UserUpdatePayload } from '../types/api';
import http from '@ohos.net.http';

class UserApi extends BaseApi {
  /**
   * 获取当前用户列表 (分页)
   */
  async getUsers(pageNum: number = 1, pageSize: number = 10): Promise<ApiResponse<PageResult<UserInfo>>> {
    // 调用基类的request方法，它会自动加上Token
    return this.request(`/users?pageNum=${pageNum}&pageSize=${pageSize}`, {
      method: http.RequestMethod.GET
    });
  }

  async UpdateUsers(username: string, userInfo: UserInfo): Promise<ApiResponse<PageResult<UserInfo>>> {
    // 调用基类的request方法，它会自动加上Token
    return this.request(`/users/{username}`, {
      method: http.RequestMethod.PUT
    });
  }

  async updateUserInfo(username: string, payload: UserUpdatePayload): Promise<ApiResponse<UserInfo>> {
    return this.request(`/users/${username}`, { // URL是 /users/{username}
      method: http.RequestMethod.PUT,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  // 根据用户名获取单个用户信息
  async getUserByUsername(username: string): Promise<ApiResponse<UserInfo>> {
    return this.request(`/users/${username}`, {
      method: http.RequestMethod.GET,
      header: { 'Content-Type': 'application/json' }
    });
  }

  // 删除用户
  async deleteUserByUsername(username: string): Promise<ApiResponse<null>> {
    return this.request(`/users/${username}`, {
      method: http.RequestMethod.DELETE,
    });
  }
} // 正确闭合类定义

export const userApi = new UserApi();
