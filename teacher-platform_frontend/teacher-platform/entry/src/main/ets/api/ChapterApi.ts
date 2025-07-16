import { BaseApi } from './BaseApi';
import {
  ApiResponse,
  PageResult,
  Chapter, CreateChapterPayload, UpdateChapterPayload
} from '../types/api';
import http from '@ohos.net.http';

class ChapterApi extends BaseApi {
  /**
   * 获取某课程下的所有章节 (分页)
   */
  async getChaptersByCourseId(
    courseId: number,
    pageNum: number = 1,
    pageSize: number = 10
  ): Promise<ApiResponse<PageResult<Chapter>>> {
    return this.request(`/courses/${courseId}/chapters?pageNum=${pageNum}&pageSize=${pageSize}`, {
      method: http.RequestMethod.GET
    });
  }

  // /**
  //  * 获取单个章节详情
  //  */
  // async getChapterById(courseId: number, chapterId: number): Promise<ApiResponse<Chapter>> {
  //   return this.request(`/courses/${courseId}/chapters/${chapterId}`, {
  //     method: http.RequestMethod.GET
  //   });
  // }

  /**
   * 新增章节
   */
  async createChapter(courseId: number, payload: CreateChapterPayload): Promise<ApiResponse<Chapter>> {
    return this.request(`/courses/${courseId}/chapters`, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  /**
   * 修改章节信息
   */
  async updateChapter(courseId: number, chapterId: number, payload: UpdateChapterPayload): Promise<ApiResponse<Chapter>> {
    return this.request(`/courses/${courseId}/chapters/${chapterId}`, {
      method: http.RequestMethod.PUT,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  /**
   * 删除章节
   */
  async deleteChapter(courseId: number, chapterId: number): Promise<ApiResponse<void>> {
    return this.request(`/courses/${courseId}/chapters/${chapterId}`, {
      method: http.RequestMethod.DELETE
    });
  }
}

export const chapterApi = new ChapterApi();
