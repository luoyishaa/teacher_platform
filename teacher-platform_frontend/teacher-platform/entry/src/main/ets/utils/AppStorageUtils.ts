// import { UserInfo } from '../types/api'; // 引入我们之前为API返回的用户信息定义的类型
// import { Course } from '../types/api';
// import { common } from '@kit.AbilityKit';
//
// // 将所有要用到的Key定义为常量并导出
// export const KEY_TOKEN = 'app_jwt_token';
// export const KEY_CURRENT_USER = 'app_current_user';
// export const KEY_IS_LOGGED_IN = 'app_is_logged_in';
// const KEY_TEMP_COURSES = 'temp_course_list_for_nav';
// export const KEY_CURRENT_COURSE_ID = 'app_current_course_id';
// export const KEY_CURRENT_CHAPTER_NAME = 'app_current_chapter_name';
// export const KEY_CURRENT_VIDEO_URL = 'app_current_video_url';
//
//
// export class AppStorageUtils {
//
//   // --- Token 相关操作 ---
//
//   /**
//    * 保存JWT Token到AppStorage
//    * @param token 登录后获取的Token字符串。如果传入null或undefined，则会删除Token。
//    */
//   static setToken(token: string | null | undefined): void {
//     if (token) {
//       AppStorage.SetOrCreate(KEY_TOKEN, token);
//     } else {
//       AppStorage.Delete(KEY_TOKEN);
//     }
//     // 联动更新登录状态
//     this.setIsLoggedIn(!!token);
//   }
//
//
//   /**
//    * 从AppStorage中获取JWT Token
//    * @returns 存储的Token字符串，如果不存在则返回undefined
//    */
//   static getToken(): string | undefined {
//     return AppStorage.Get(KEY_TOKEN) as (string | undefined);
//   }
//
//   // --- 登录状态相关操作 ---
//
//   /**
//    * 设置当前的登录状态
//    * (这个方法通常由setToken自动调用，但也可以手动调用)
//    * @param isLoggedIn 是否已登录
//    */
//   static setIsLoggedIn(isLoggedIn: boolean): void {
//     AppStorage.SetOrCreate(KEY_IS_LOGGED_IN, isLoggedIn);
//   }
//
//   /**
//    * 检查用户是否已登录
//    * 这个方法可以直接在代码逻辑中使用
//    * @returns 如果已登录则返回true，否则返回false
//    */
//   static isLoggedIn(): boolean {
//     // 使用 '??' (空值合并运算符) 来处理可能为undefined的情况，更安全
//     return (AppStorage.Get(KEY_IS_LOGGED_IN) as boolean) ?? false;
//   }
//
//   // --- 用户信息相关操作 ---
//
//   /**
//    * 保存当前登录的用户信息
//    * @param user 用户信息对象。如果传入null或undefined，则会删除用户信息。
//    */
//   static setCurrentUser(user: UserInfo | null | undefined): void {
//     if (user) {
//       // 存入对象时，先将其序列化为JSON字符串
//       AppStorage.SetOrCreate(KEY_CURRENT_USER, JSON.stringify(user));
//     } else {
//       AppStorage.Delete(KEY_CURRENT_USER);
//     }
//   }
//
//   /**
//    * 获取当前登录的用户信息
//    * @returns 解析后的UserInfo对象，如果不存在或解析失败则返回null
//    */
//   static getCurrentUser(): UserInfo | null {
//     const userJson = AppStorage.Get(KEY_CURRENT_USER) as (string | undefined);
//     if (userJson) {
//       try {
//         // 读取后，将JSON字符串反序列化为对象
//         return JSON.parse(userJson) as UserInfo;
//       } catch (error) {
//         console.error("AppStorageUtils: Failed to parse user info from AppStorage.", error);
//         return null;
//       }
//     }
//     return null;
//   }
//
//
//
//   /**
//    * 从临时存储中获取课程列表，获取后立即删除，确保是一次性的
//    * @returns 课程数组，如果不存在则返回null
//    */
//   static getAndClearTempCourses(): Course[] | null {
//     const courses = AppStorage.Get(KEY_TEMP_COURSES) as (Course[] | undefined);
//     if (courses) {
//       AppStorage.Delete(KEY_TEMP_COURSES); // 取完就删，避免数据污染
//       return courses;
//     }
//     return null;
//   }
//
//   static setAppContext(context: common.UIAbilityContext): void {
//     // AppStorage不能直接存储复杂的对象实例，但我们可以把它存入一个全局变量
//     // 或者利用一个更简单的技巧，在Stage模型下，ApplicationContext是全局可用的
//     // 但为了确保我们拿到的是UIAbility的context，我们这样做：
//     globalThis.arkTsAppContext = context;
//     // AppStorage.Set(KEY_APP_CONTEXT, context); // 直接存入AppStorage可能因序列化问题失败
//   }
//
//   /**
//    * (在FileApi中调用) 获取全局的UIAbility上下文
//    * @returns UIAbility的上下文
//    */
//   static getAppContext(): common.UIAbilityContext | undefined {
//     return globalThis.arkTsAppContext as (common.UIAbilityContext | undefined);
//     // return AppStorage.Get(KEY_APP_CONTEXT) as (common.UIAbilityContext | undefined);
//   }
//
//   /**
//    * 存储当前课程ID（number 类型）
//    * @param courseId 当前课程ID，若为 null 或 undefined 则删除该字段
//    */
//   static setCurrentCourseId(courseId: number | null | undefined): void {
//     if (courseId !== null && courseId !== undefined) {
//       AppStorage.SetOrCreate(KEY_CURRENT_COURSE_ID, courseId);
//     } else {
//       AppStorage.Delete(KEY_CURRENT_COURSE_ID);
//     }
//   }
//
//   /**
//    * 获取当前存储的课程ID
//    * @returns 返回 course_id 数字类型，若不存在则返回 null
//    */
//   static getCurrentCourseId(): number | null {
//     const courseId = AppStorage.Get(KEY_CURRENT_COURSE_ID) as (number | undefined);
//     return courseId ?? null;
//   }
//
//   static setCurrentChapterName(name: string): void {
//     AppStorage.SetOrCreate(KEY_CURRENT_CHAPTER_NAME, name);
//   }
//
//   static getCurrentChapterName(): string | null {
//     return AppStorage.Get(KEY_CURRENT_CHAPTER_NAME) as (string | undefined) ?? null;
//   }
//
//   static setVideoUrl(url: string): void {
//     AppStorage.SetOrCreate(KEY_CURRENT_VIDEO_URL, url);
//   }
//
//   static getVideoUrl(): string | null {
//     return AppStorage.Get(KEY_CURRENT_VIDEO_URL) as (string | undefined) ?? null;
//   }
//
//
//
// }

import { UserInfo } from '../types/api'; // 引入我们之前为API返回的用户信息定义的类型
import { Course } from '../types/api';
import { common } from '@kit.AbilityKit';

// 将所有要用到的Key定义为常量并导出
export const KEY_TOKEN = 'app_jwt_token';
export const KEY_CURRENT_USER = 'app_current_user';
export const KEY_IS_LOGGED_IN = 'app_is_logged_in';
const KEY_TEMP_COURSES = 'temp_course_list_for_nav';
export const KEY_CURRENT_COURSE_ID = 'app_current_course_id';
const KEY_CURRENT_CHAPTER_ID='app_current_chapter_id'
export const KEY_CURRENT_VIDEO_URL = 'app_current_video_url';
export const KEY_CURRENT_CHAPTER_NAME ='app_current_chapter_name';
export const KEY_CURRENT_CHAPTER_DESCRIPTION ='app_current_chapter_description';

export class AppStorageUtils {

  // --- Token 相关操作 ---

  /**
   * 保存JWT Token到AppStorage
   * @param token 登录后获取的Token字符串。如果传入null或undefined，则会删除Token。
   */
  static setToken(token: string | null | undefined): void {
    if (token) {
      AppStorage.SetOrCreate(KEY_TOKEN, token);
    } else {
      AppStorage.Delete(KEY_TOKEN);
    }
    // 联动更新登录状态
    this.setIsLoggedIn(!!token);
  }


  /**
   * 从AppStorage中获取JWT Token
   * @returns 存储的Token字符串，如果不存在则返回undefined
   */
  static getToken(): string | undefined {
    return AppStorage.Get(KEY_TOKEN) as (string | undefined);
  }

  // --- 登录状态相关操作 ---

  /**
   * 设置当前的登录状态
   * (这个方法通常由setToken自动调用，但也可以手动调用)
   * @param isLoggedIn 是否已登录
   */
  static setIsLoggedIn(isLoggedIn: boolean): void {
    AppStorage.SetOrCreate(KEY_IS_LOGGED_IN, isLoggedIn);
  }

  /**
   * 检查用户是否已登录
   * 这个方法可以直接在代码逻辑中使用
   * @returns 如果已登录则返回true，否则返回false
   */
  static isLoggedIn(): boolean {
    // 使用 '??' (空值合并运算符) 来处理可能为undefined的情况，更安全
    return (AppStorage.Get(KEY_IS_LOGGED_IN) as boolean) ?? false;
  }

  // --- 用户信息相关操作 ---

  /**
   * 保存当前登录的用户信息
   * @param user 用户信息对象。如果传入null或undefined，则会删除用户信息。
   */
  static setCurrentUser(user: UserInfo | null | undefined): void {
    if (user) {
      // 存入对象时，先将其序列化为JSON字符串
      AppStorage.SetOrCreate(KEY_CURRENT_USER, JSON.stringify(user));
    } else {
      AppStorage.Delete(KEY_CURRENT_USER);
    }
  }

  /**
   * 获取当前登录的用户信息
   * @returns 解析后的UserInfo对象，如果不存在或解析失败则返回null
   */
  static getCurrentUser(): UserInfo{
    const userJson = AppStorage.Get(KEY_CURRENT_USER) as (string | undefined);
    if (userJson) {
      try {
        // 读取后，将JSON字符串反序列化为对象
        return JSON.parse(userJson) as UserInfo;
      } catch (error) {
        console.error("AppStorageUtils: Failed to parse user info from AppStorage.", error);
        return null;
      }
    }
    return null;
  }



  /**
   * 从临时存储中获取课程列表，获取后立即删除，确保是一次性的
   * @returns 课程数组，如果不存在则返回null
   */
  static getAndClearTempCourses(): Course[] | null {
    const courses = AppStorage.Get(KEY_TEMP_COURSES) as (Course[] | undefined);
    if (courses) {
      AppStorage.Delete(KEY_TEMP_COURSES); // 取完就删，避免数据污染
      return courses;
    }
    return null;
  }

  static setAppContext(context: common.UIAbilityContext): void {
    // AppStorage不能直接存储复杂的对象实例，但我们可以把它存入一个全局变量
    // 或者利用一个更简单的技巧，在Stage模型下，ApplicationContext是全局可用的
    // 但为了确保我们拿到的是UIAbility的context，我们这样做：
    globalThis.arkTsAppContext = context;
    // AppStorage.Set(KEY_APP_CONTEXT, context); // 直接存入AppStorage可能因序列化问题失败
  }

  /**
   * (在FileApi中调用) 获取全局的UIAbility上下文
   * @returns UIAbility的上下文
   */
  static getAppContext(): common.UIAbilityContext | undefined {
    return globalThis.arkTsAppContext as (common.UIAbilityContext | undefined);
    // return AppStorage.Get(KEY_APP_CONTEXT) as (common.UIAbilityContext | undefined);
  }

  /**
   * 存储当前课程ID
   * @param courseId 当前课程ID，若为 null 或 undefined 则删除该字段
   */
  static setCurrentCourseId(courseId: number | null | undefined): void {
    if (courseId) {
      AppStorage.SetOrCreate(KEY_CURRENT_COURSE_ID, courseId);
    } else {
      AppStorage.Delete(KEY_CURRENT_COURSE_ID);
    }
  }

  /**
   * 获取当前存储的课程ID
   * @returns 返回 course_id 字符串，若不存在则返回 null
   */
  static getCurrentCourseId(): number | null {
    const courseId = AppStorage.Get(KEY_CURRENT_COURSE_ID) as (number | undefined);
    return courseId ?? null;
  }

  static setCurrentChapterName(chapterName: string): void {
    if (chapterName) {
      AppStorage.SetOrCreate(KEY_CURRENT_CHAPTER_NAME, chapterName);
    } else {
      AppStorage.Delete(KEY_CURRENT_CHAPTER_NAME);
    }
  }

  static getCurrentChapterName(): string{
    const chapterName = AppStorage.Get(KEY_CURRENT_CHAPTER_NAME) as (string | undefined);
    return chapterName ?? null;
  }

  static setCurrentVideoUrl(videoUrl: string| undefined): void {
    if (videoUrl) {
      AppStorage.SetOrCreate(KEY_CURRENT_VIDEO_URL, videoUrl);
    } else {
      AppStorage.Delete(KEY_CURRENT_VIDEO_URL);
    }
  }

  static getCurrentVideoUrl(): string{
    const videoUrl = AppStorage.Get(KEY_CURRENT_VIDEO_URL) as (string | undefined);
    return videoUrl ?? null;
  }

  static setCurrentChapterDes(chapterdes: string): void {
    if (chapterdes) {
      AppStorage.SetOrCreate(KEY_CURRENT_CHAPTER_DESCRIPTION, chapterdes);
    } else {
      AppStorage.Delete(KEY_CURRENT_CHAPTER_DESCRIPTION);
    }
  }

  static getCurrentChapterDes(): string{
    const chapterdes = AppStorage.Get(KEY_CURRENT_CHAPTER_DESCRIPTION) as (string | undefined);
    return chapterdes ?? null;
  }

}