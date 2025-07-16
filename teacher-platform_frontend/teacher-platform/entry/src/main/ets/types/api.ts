// // ================== 1. 通用结构 ==================
//
// /**
//  * 全局统一的API响应结构
//  * @template T 泛型参数，代表data字段的具体类型
//  */
// export interface ApiResponse<T> {
//   code: number;
//   message: string;
//   data: T;
// }
//
// /**
//  * 通用分页查询结果结构
//  * @template T 泛型参数，代表记录列表中的元素类型
//  */
// export interface PageResult<T> {
//   total: number;
//   records: T[];
// }
//
// // ================== 2. 核心业务对象类型 ==================
//
// /**
//  * 用户信息类型 (不包含密码等敏感信息)
//  */
// export interface UserInfo {
//   id: number;
//   username: string;
//   role: string;
//   createTime?: string;
//   avatar:string;
// }
//
// // 课程类型
// export interface ApiCourse {
//   courseId: number;
//   courseName: string;
//   description: string;
//   createTime: string;
//   updateTime: string;
//   username: string;
//   courseImg: string;
// }
//
// // 前端使用的课程类型
// export interface Course {
//   title: string;
//   description: string;
//   image: {
//     type: number;
//     url: string;
//     alt?: string;
//   };
//   bgColor: string;
//   rawData?: any; // 保留原始API数据
// }
//
// /**
//  * 章节信息类型
//  */
// export interface Chapter {
//   id: number;
//   courseId: number;
//   name: string;
//   videoUrl: string;
// }
//
// /**
//  * 教学资源类型
//  */
// export interface Resource {
//   id: number;
//   resourceName: string;
//   fileUrl: string;
//   uploaderName: string;
//   createTime: string;
// }
//
// /**
//  * 操作日志类型
//  */
// export interface OperationLog {
//   id: number;
//   username: string;
//   description: string;
//   method: string;
//   ip: string;
//   createTime: string;
// }
//
//
// // ================== 3. 特定API的data结构 ==================
//
// /**
//  * 登录成功时，API响应中data字段的结构
//  */
// export interface LoginSuccessData {
//   token: string;
//   userInfo: UserInfo;
// }
//
// export type RegisterSuccessData = UserInfo;
//
// export interface RegisterPayload {
//   username: string;
//   password: string;
//   role: 'admin' | 'teacher';
// }
//
// export interface LoginPayload {
//   username: string;
//   password: string;
// }
//
export interface UserUpdatePayload {
  username?: string;
  password?: string;
  avatar?: string;
}
//
// export interface  CreateChapterPayload {
//   chapterName: string;
//   description:string;
//   video?: string;
//   ppt?: string;
// }
//
// export interface  UpdateChapterPayload {
//   chapterName: string;
//   description:string;
//   video?: string;
//   ppt?: string;
// }
//
// export interface  CreateCoursePayload {
//   courseName: string;
//   description:string;
//   courseImg?: string;
// }
//
// export interface  UpdateCoursePayload {
//   course_id:number;
//   courseName: string;
//   description:string;
//   courseImg?: string;
// }
// ================== 1. 通用结构 ==================

/**
 * 全局统一的API响应结构
 * @template T 泛型参数，代表data字段的具体类型
 */
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

/**
 * 通用分页查询结果结构
 * @template T 泛型参数，代表记录列表中的元素类型
 */
export interface PageResult<T> {
  total: number;
  records: T[];
}

// ================== 2. 核心业务对象类型 ==================

/**
 * 用户信息类型 (不包含密码等敏感信息)
 */
export interface UserInfo {
  id: number;
  username: string;
  role: string;
  createTime?: string;
  avatar:string;
}

// 课程类型
export interface ApiCourse {
  courseId: number;
  courseName: string;
  description: string;
  createTime: string;
  updateTime: string;
  username: string;
  courseImg: string;
}

// 前端使用的课程类型
export interface Course {
  title: string;
  description: string;
  image: {
    type: number;
    url: string;
    alt?: string;
  };
  bgColor: string;
  rawData?: any; // 保留原始API数据
}

/**
 * 章节信息类型
 */
export interface Chapter {
  chapterId: number;
  courseId: number;
  chapterName: string;
  description: string;
  video: string;
  ppt: string;
}
/**
 * 教学资源类型
 */
export interface Resource {
  id: number;
  resourceName: string;
  fileUrl: string;
  uploaderName: string;
  createTime: string;
}

/**
 * 操作日志类型
 */
export interface OperationLog {
  id: number;
  username: string;
  description: string;
  method: string;
  ip: string;
  createTime: string;
}


// ================== 3. 特定API的data结构 ==================

/**
 * 登录成功时，API响应中data字段的结构
 */
export interface LoginSuccessData {
  token: string;
  userInfo: UserInfo;
}

export type RegisterSuccessData = UserInfo;

export interface RegisterPayload {
  username: string;
  password: string;
  role: 'admin' | 'teacher';
}

export interface LoginPayload {
  username: string;
  password: string;
}

// export interface UserUpdatePayload {
//   username?: string;
//   password?: string;
//   avatarUrl?: string;
// }
export interface  CreateChapterPayload {
  chapterName: string;
  description:string;
  video?: string;
  ppt?: string;
}

export interface  UpdateChapterPayload {
  chapterName: string;
  description:string;
  video?: string;
  ppt?: string;
}

export interface  CreateCoursePayload {
  courseName: string;
  description:string;
  courseImg?: string;
}

export interface  UpdateCoursePayload {
  course_id:number;
  courseName: string;
  description:string;
  courseImg?: string;
}

