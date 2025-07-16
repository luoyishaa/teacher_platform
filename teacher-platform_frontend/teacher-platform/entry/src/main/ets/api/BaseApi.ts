// api/BaseApi.ts
import http from '@ohos.net.http';
import { ApiResponse } from '../types/api';
import { AppStorageUtils } from '../utils/AppStorageUtils';
// ip需要获取后端地址
// const BASE_URL = 'http://192.168.80.84:8088';
// export const BASE_URL = 'http://192.168.232.1:8088';
export const BASE_URL = 'http://192.168.80.95:8088';

export class BaseApi {
  protected async request<T>(
    url: string,
    options: http.HttpRequestOptions,
    requiresAuth: boolean = true
  ): Promise<ApiResponse<T>> {

    const httpRequest = http.createHttp();
    const fullUrl = `${BASE_URL}${url}`;
    const finalHeaders = { ...options.header };
    let tokenForLog: string | undefined = undefined; // 用于日志记录

    if (requiresAuth) {
      const token = AppStorageUtils.getToken();
      tokenForLog = token; // 记录一下我们找到的token
      if (token) {
        finalHeaders['Authorization'] = `Bearer ${token}`;
      }
    }
    options.header = finalHeaders;

    // 在发送请求前，打印所有信息
    console.log("==================== [API Request Start] ====================");
    console.log(`[URL]: ${options.method || 'GET'} ${fullUrl}`);
    console.log(`[Token Found]: ${tokenForLog ? 'Yes' : 'No'}`); // 打印是否找到了Token
    // console.log('[Headers]:', JSON.stringify(options.header)); // 看header
    // console.log('[Body]:', options.extraData ? options.extraData.toString() : 'None'); // 看Body

    try {
      const response = await httpRequest.request(fullUrl, options);
      console.log(`[Response Status]: ${response.responseCode} for ${fullUrl}`);
      console.log("==================== [API Request End] ======================");
      if (response.result) {
        return JSON.parse(response.result as string) as ApiResponse<T>;
      } else {
        throw new Error(`服务器返回空响应，状态码: ${response.responseCode}`);
      }

    } catch (err) {
      console.error(`Request to ${fullUrl} failed:`, JSON.stringify(err));
      throw err;

    } finally {
      httpRequest.destroy();
    }
  }
}