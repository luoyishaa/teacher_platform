import { BaseApi } from './BaseApi';
import { ApiResponse, RegisterPayload, LoginSuccessData, LoginPayload, RegisterSuccessData } from '../types/api'; // 2. 引入所有需要的数据类型
import http from '@ohos.net.http';

/**
 * 认证相关的API封装类
 * 它继承了BaseApi，因此可以直接使用 this.request 方法
 */
class AuthApi extends BaseApi {

  /**
   * 用户登录
   * @param payload 包含用户名和密码的对象
   * @returns 返回一个Promise，其解析值为我们统一的ApiResponse结构
   */
  async login(payload: LoginPayload): Promise<ApiResponse<LoginSuccessData>> {
    // 调用父类的request方法，它会自动处理拼接URL、加Token、发送请求、解析JSON等
    return this.request('/auth/login', { // URL是相对路径
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  /**
   * 用户注册
   * @param payload 包含用户名、密码、角色的对象
   * @returns 返回一个Promise，其解析值为我们统一的ApiResponse结构
   */
  async register(payload: RegisterPayload): Promise<ApiResponse<RegisterSuccessData>> {
    return this.request('/auth/register', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }
}

// 导出一个AuthApi的单例，方便在项目其他地方直接使用
export const authApi = new AuthApi();