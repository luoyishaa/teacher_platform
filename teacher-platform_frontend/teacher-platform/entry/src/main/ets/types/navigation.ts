import { Course } from './api'; // 导入我们定义的ApiCourse类型

/**
 * 定义通用的导航路径对象结构
 */
export interface NavPathInfo {
  name: string;
  param?: any;
}

// export interface NavPathInfo {
//   name: string;
//   param?: ClassManageParams; // 让param的类型更具体，而不是any
// }

/**
 * 定义跳转到课程管理页面时，需要传递的参数结构
 */
export interface ClassManageParams {
  courses: Course[]; // 参数包含一个名为courses的、类型为Course数组的字段
}

