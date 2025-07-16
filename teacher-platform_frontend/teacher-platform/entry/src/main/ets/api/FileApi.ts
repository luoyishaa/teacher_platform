import http from '@ohos.net.http';
import fs from '@ohos.file.fs';
import { BaseApi } from './BaseApi';
import { ApiResponse } from '../types/api';

class FileApi extends BaseApi {
  public async uploadFile(fileUri: string, fileName: string): Promise<string> {
    // 将本地文件读取为二进制的 ArrayBuffer
    const file = fs.openSync(fileUri, fs.OpenMode.READ_ONLY);
    const stat = fs.statSync(file.fd);
    const buffer = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);
    const boundary = `----WebKitFormBoundary${new Date().getTime().toString(16)}`;

    // 构建 multipart/form-data 请求体
    const finalBuffer = this.createMultipartBody(buffer, boundary, fileName);

    // 构建 HttpRequestOptions
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      // 置正确的 Content-Type，并包含 boundary
      header: {
        'Content-Type': `multipart/form-data; boundary=${boundary}`
      },
      extraData: finalBuffer // 请求体是构建好的二进制数据
    };

    try {
      // 调用父类 BaseApi 的 request 方法
      // 后端返回 ApiResponse<String>，所以这里泛型是 <string>
      const response: ApiResponse<string> = await this.request<string>('/files/upload', options, true);

      // 根据后端业务码判断是否成功
      if (response && (response.code === 0 || response.code === 200)) {
        return response.message; // 返回最终的文件URL
      } else {
        // 业务失败，抛出后端返回的错误信息
        throw new Error(response.message || '服务器处理上传失败');
      }
    } catch (error) {
      console.error('Upload failed in FileApi:', JSON.stringify(error));
      // 将错误继续向上抛出，以便UI层捕获
      throw error;
    }
  }

  /**
   * 辅助方法：构建 multipart/form-data 请求体
   */
  private createMultipartBody(fileBuffer: ArrayBuffer, boundary: string, fileName: string): ArrayBuffer {
    const boundaryPrefix = `--${boundary}\r\n`;
    const boundarySuffix = `\r\n--${boundary}--`;

    // 请求体头部
    let requestBody = boundaryPrefix;
    requestBody += `Content-Disposition: form-data; name="file"; filename="${fileName}"\r\n`;
    requestBody += `Content-Type: application/octet-stream\r\n\r\n`;

    // 将字符串头、文件二进制内容和结尾的 boundary 合并成一个 ArrayBuffer
    const headerBuffer = this.stringToBuffer(requestBody);
    const endBuffer = this.stringToBuffer(boundarySuffix);

    const combinedBuffer = this.appendBuffer(headerBuffer, fileBuffer);
    const finalBuffer = this.appendBuffer(combinedBuffer, endBuffer);

    return finalBuffer;
  }

  // --- 二进制数据处理的辅助函数 ---

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
}

// 导出一个单例，方便在各个页面中直接引用
export const fileApi = new FileApi();