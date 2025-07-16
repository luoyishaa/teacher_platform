import { BaseApi } from './BaseApi';
import {
  ApiResponse,
  PageResult,
  ApiCourse,
  Chapter,
  UpdateChapterPayload,
  CreateChapterPayload,
  CreateCoursePayload
} from '../types/api';
import http from '@ohos.net.http';

class CourseApi extends BaseApi {
  /**
   * 获取当前用户课程列表 (分页)
   */
  async getMyCourses(pageNum: number = 1, pageSize: number = 10): Promise<ApiResponse<PageResult<ApiCourse>>> {
    return this.request(`/courses?pageNum=${pageNum}&pageSize=${pageSize}`, {
      method: http.RequestMethod.GET
    });
  }

  /**
   * 根据课程ID获取课程详情
   */
  async getCourseById(courseId: number): Promise<ApiResponse<ApiCourse>> {
    return this.request(`/courses/${courseId}`, {
      method: http.RequestMethod.GET
    });
  }

  /**
   * 新增课程
   */
  async createCourse(payload: CreateCoursePayload): Promise<ApiResponse<ApiCourse>> {
    return this.request('/courses', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  /**
   * 更新课程信息
   */
  async updateCourse(courseId: number, payload: UpdateChapterPayload): Promise<ApiResponse<ApiCourse>> {
    return this.request(`/courses/${courseId}`, {
      method: http.RequestMethod.PUT,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(payload)
    });
  }

  /**
   * 删除课程
   */
  async deleteCourse(courseId: number): Promise<ApiResponse<ApiCourse>> {
    return this.request(`/courses/${courseId}`, {
      method: http.RequestMethod.DELETE
    });
  }
}

export const courseApi = new CourseApi();
