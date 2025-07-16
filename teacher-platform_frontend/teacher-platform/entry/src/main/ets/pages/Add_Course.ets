import { courseApi } from "../api/CourseApi";
import { CreateCoursePayload } from "../types/api";
import { AppStorageUtils } from "../utils/AppStorageUtils";

// 跳转页面入口函数
@Builder
export function Add_CourseBuilder() {
  Add_Course()
}

// 定义课程数据结构类型
interface Course {
  // courseId: number;
  courseName: string;
  description: string;
  createTime: string;
  updateTime: string;
  username: string;
  courseImg?: Resource;
}

export interface UserInfo {
  id: number;
  username: string;
  role: string;
  createTime?: string;
  avatar:string;
}

@Component
struct Add_Course {
  pathStack: NavPathStack = new NavPathStack();
  @State courseName: string = '';
  @State description: string = '';
  @State courseImg: Resource = $rawfile('pic1.png'); // 默认图片

  async submit() {
    const storedUserId = AppStorageUtils.getCurrentUser()?.username;
    const newCourse: CreateCoursePayload = {
      // courseId: Math.floor(Math.random() * 1000), // 模拟生成 courseId
      courseName: this.courseName,
      description: this.description,
    };

    console.info('新课程信息:', JSON.stringify(newCourse));
    // TODO:

    const storeduserId = AppStorageUtils.getCurrentUser().id;
    const response = await courseApi.createCourse(newCourse);

    // 返回上一页
    this.pathStack.pop();
    this.pathStack.replacePathByName("Course_Manage", null, false);
  }

  build() {
    NavDestination() {
      Column() {
        // 页面标题
        Text('创建新课程')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 20, bottom: 30 })

        // 课程名称输入框
        TextInput({ placeholder: '请输入课程名称' })
          .onChange((value: string) => {
            this.courseName = value;
          })
          .width('90%')
          .height(50)
          .fontSize(16)
          .border({ color: '#ccc', width: 1, radius: 8 })
          .padding({ left: 10 })

        // 课程描述输入框
        TextInput({ placeholder: '请输入课程描述' })
          .onChange((value: string) => {
            this.description = value;
          })
          .width('90%')
          .height(100)
          .fontSize(16)
          .border({ color: '#ccc', width: 1, radius: 8 })
          .padding({ left: 10 })
          .margin({ top: 20 })

        // 课程封面图片选择器（可选）
        Row({ space: 10 }) {
          Image(this.courseImg)
            .width(80)
            .height(80)
            .border({ radius: 8 })

            //   Text('选择封面图片')
            //     .fontSize(16)
            //     .fontColor('#007AFF')
            // }
            // .onClick(() => {
            //   // TODO: 实现图片选择逻辑，例如使用 ImagePicker
            // })
            .margin({ top: 20 })

          // 提交按钮
          Button('提交')
            .onClick(() => {
              this.submit();
            })
            .width('90%')
            .height(50)
            .fontSize(18)
            .backgroundColor('#72BFF9')
            .fontColor('#fff')
            .borderRadius(10)
            .margin({ top: 30 })

          // 取消按钮
          Button('取消')
            .onClick(() => {
              this.pathStack.pop();
            })
            .width('90%')
            .height(50)
            .fontSize(18)
            .backgroundColor('#E0E0E0')
            .fontColor('#333')
            .borderRadius(10)
            .margin({ top: 10 })
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
      }

    }
    .title('创建新课程页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}