// ResourceApi.ts
import { BaseApi } from './BaseApi';
import { ApiResponse } from '../types/api';
import http from '@ohos.net.http';
import fs from '@ohos.file.fs';

// 定义资源相关类型
export interface Resource {
  id: number;
  resourceName: string;
  fileUrl: string;
  createTime: string;
  uploaderName: string;
}

interface ResourceListResponse {
  total: number;
  records: Resource[];
}

class ResourceApi extends BaseApi {
  /**
   * 获取资源列表
   */
  async getResources(): Promise<ApiResponse<ResourceListResponse>> {
    return this.request('/resources', {
      method: http.RequestMethod.GET
    });
  }

  /**
   * 上传资源文件
   * @param fileUri 文件路径
   * @param fileName 文件名
   */
  async uploadResource(fileUri: string, fileName: string): Promise<ApiResponse<Resource>> {
    // 打开并读取文件为 ArrayBuffer
    const file = fs.openSync(fileUri, fs.OpenMode.READ_ONLY);
    const stat = fs.statSync(file.fd);
    const buffer = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);

    // 构建 boundary 和请求体
    const boundary = `----WebKitFormBoundary${new Date().getTime().toString(16)}`;
    const finalBuffer = this.createMultipartBody(buffer, boundary, fileName);

    // 构建请求选项
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': `multipart/form-data; boundary=${boundary}`
      },
      extraData: finalBuffer
    };

    try {
      // 调用父类 request 方法，返回类型为 ApiResponse<Resource>
      const response: ApiResponse<Resource> = await this.request<Resource>(
        '/resources',
        options,
        true
      );

      if (response && (response.code === 0 || response.code === 200)) {
        return response;
      } else {
        throw new Error(response.message || '服务器处理上传失败');
      }
    } catch (error) {
      console.error('Upload failed in ResourceApi:', JSON.stringify(error));
      throw error;
    }
  }

  /**
   * 辅助方法：构建 multipart/form-data 请求体
   */
  private createMultipartBody(
    fileBuffer: ArrayBuffer,
    boundary: string,
    fileName: string
  ): ArrayBuffer {
    const boundaryPrefix = `--${boundary}\r\n`;
    const boundarySuffix = `\r\n--${boundary}--`;

    let requestBody = boundaryPrefix;
    requestBody += `Content-Disposition: form-data; name="file"; filename="${fileName}"\r\n`;
    requestBody += `Content-Type: application/octet-stream\r\n\r\n`;

    const headerBuffer = this.stringToBuffer(requestBody);
    const endBuffer = this.stringToBuffer(boundarySuffix);

    const combinedBuffer = this.appendBuffer(headerBuffer, fileBuffer);
    return this.appendBuffer(combinedBuffer, endBuffer);
  }

  // --- 二进制数据处理辅助函数 ---

  private stringToBuffer(str: string): ArrayBuffer {
    const buffer = new ArrayBuffer(str.length);
    const dataView = new DataView(buffer);
    for (let i = 0; i < str.length; i++) {
      dataView.setUint8(i, str.charCodeAt(i));
    }
    return buffer;
  }

  private appendBuffer(buffer1: ArrayBuffer, buffer2: ArrayBuffer): ArrayBuffer {
    const tmp = new Uint8Array(buffer1.byteLength + buffer2.byteLength);
    tmp.set(new Uint8Array(buffer1), 0);
    tmp.set(new Uint8Array(buffer2), buffer1.byteLength);
    return tmp.buffer;
  }

  /**
   * 删除资源
   * @param resourceId 资源ID
   */
  async deleteResource(resourceId: number): Promise<ApiResponse<null>> {
    return this.request(`/resources/${resourceId}`, {
      method: http.RequestMethod.DELETE
    });
  }

  async getResourceById(resourceId: number): Promise<ApiResponse<Resource>> {
    return this.request(`/resource/${resourceId}`, {
      method: http.RequestMethod.GET
    });
  }


}

export const resourceApi = new ResourceApi();
