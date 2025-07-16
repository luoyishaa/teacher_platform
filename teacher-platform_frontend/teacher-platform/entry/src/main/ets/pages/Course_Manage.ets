// import { courseApi } from '../api/CourseApi';
// import {
//   ApiCourse
// } from '../types/api';
// import { AppStorageUtils } from '../utils/AppStorageUtils';
//
// @Builder
// export function Course_ManageBuilder() {
//   Course_Manage();
// }
//
// interface CourseWithColor extends ApiCourse {
//   bgColor: string;
// }
// interface EmptyParams {}
//
// @Component
// struct Course_Manage {
//   @State courses: Array<CourseWithColor> = [];
//   pathStack: NavPathStack = new NavPathStack();
//
//   build() {
//     NavDestination() {
//       Column() {
//         if (this.courses.length === 0) {
//           Text('您还没有创建任何课程')
//             .fontSize(18)
//             .fontColor(Color.Gray)
//             .textAlign(TextAlign.Center)
//             .width('100%')
//             .margin({ top: 50 });
//         } else {
//           List() {
//             ForEach(this.courses, (course: CourseWithColor) => {
//               ListItem() {
//                 Row() {
//                   Image(course.courseImg)
//                     .width(100)
//                     .height(100)
//                     .border({ radius: 8 })
//                     .margin({ right: 10 });
//
//                   Column() {
//                     Text(course.courseName)
//                       .fontColor(Color.Black)
//                       .fontSize(20)
//                       .fontWeight(FontWeight.Bold)
//                       .margin({ bottom: 25 });
//
//                     Text(course.description)
//                       .fontColor(Color.Gray)
//                       .fontSize(15);
//                   }
//                   .layoutWeight(1)
//                   .alignItems(HorizontalAlign.Start);
//
//                   Image($rawfile('ArrowToRight.png'))
//                     .width(30)
//                     .height(30)
//                     .onClick(() => {
//                       AppStorageUtils.setCurrentCourseId(course.courseId);
//                       this.pathStack.pushPathByName("Course_Detail", {} as EmptyParams, false);
//                     });
//                 }
//                 .height(150)
//                 .backgroundColor(course.bgColor)
//                 .margin({ bottom: 10 })
//                 .border({ radius: 10 });
//               }
//             }, (item: CourseWithColor) => item.courseId.toString());
//           }
//           .width('90%')
//           .margin({ bottom: 10, left: 10 });
//         }
//
//         Button('新增课程')
//           .width('90%')
//           .height(50)
//           .fontSize(18)
//           .backgroundColor('#4CAF50')
//           .fontColor('#fff')
//           .borderRadius(10)
//           .margin({ top: 20, bottom: 20 })
//           .onClick(() => {
//             this.pathStack.pushPathByName("Add_Course", {} as EmptyParams, false);
//           });
//       }
//       .padding({ left: 10, right: 10 })
//     }
//     .title('课程管理页')
//     .onReady((context: NavDestinationContext) => {
//       this.pathStack = context.pathStack;
//     });
//   }
//
//   aboutToAppear() {
//     this.fetchCourses();
//   }
//
//   private async fetchCourses() {
//     try {
//       const res = await courseApi.getMyCourses(1, 10);
//       if (res.code === 200 && res.data?.records) {
//         this.courses = res.data.records.map((item: ApiCourse) => ({
//           courseId: item.courseId,
//           courseName: item.courseName,
//           description: item.description,
//           createTime: item.createTime,
//           updateTime: item.updateTime,
//           username: item.username,
//           courseImg: item.courseImg,
//           bgColor: this.getColorById(item.courseId)
//         }as CourseWithColor));
//       } else {
//         console.error('获取课程失败:', res.message);
//         this.courses = [];
//       }
//     } catch (err) {
//       console.error('请求异常:', err);
//       this.courses = [];
//     }
//   }
//
//   private getColorById(id: number): string {
//     const colors = ['#B8E2DC', '#FCEBB5', '#C9E4F3', '#D8F0D1', '#F4C2C2', '#CDE7FF', '#E6F7E6', '#FFFACD'];
//     return colors[id % colors.length];
//   }
// }
import { courseApi } from '../api/CourseApi';
import {
  ApiCourse
} from '../types/api';
import { AppStorageUtils } from '../utils/AppStorageUtils';
@Builder
export function Course_ManageBuilder() {
  Course_Manage();
}

interface CourseWithColor extends ApiCourse {
  bgColor: string;
}
interface EmptyParams {}

@Component
struct Course_Manage {
  @State courses: Array<CourseWithColor> = [];
  pathStack: NavPathStack = new NavPathStack();

  private getRandomPic(): string {
    const index = Math.floor(Math.random() * 6) + 1; // 生成 1~6 的随机数
    return `pic${index}.png`;
  }


  build() {
    NavDestination() {
      Column() {
        Stack() {
          Image($rawfile('Background_Mainpage.png')).width('100%').height('100%');

          Column() {
            Row() {
              Blank();
              Text('创建新课程')
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 5 });
              Image($rawfile('Add.png'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.pathStack.pushPathByName("Add_Course", {} as EmptyParams, false);
                });
            }
            .margin({ bottom: 10, right: 10 })
            .width('100%');

            Text('所有课程')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 10 });

            if (this.courses.length === 0) {
              Text('您还没有创建任何课程')
                .fontSize(18)
                .fontColor(Color.Gray)
                .textAlign(TextAlign.Center)
                .width('100%')
                .margin({ top: 50 });
            } else {
              List() {
                ForEach(this.courses, (course: CourseWithColor) => {
                  ListItem() {
                    Row() {
                      Image($rawfile(this.getRandomPic()))
                        .width(100)
                        .height(100)
                        .border({ radius: 8 })
                        .margin({ right: 10 });
                      Column() {
                        Text(course.courseName)
                          .fontColor(Color.Black)
                          .fontSize(20)
                          .fontWeight(FontWeight.Bold)
                          .margin({ bottom: 25 });

                        Text(course.description)
                          .fontColor(Color.Gray)
                          .fontSize(15);
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start);

                      // Image($rawfile('ArrowToRight.png'))
                      //   .width(30)
                      //   .height(30)
                      //   .onClick(() => {
                      //     AppStorageUtils.setCurrentCourseId(course.courseId);
                      //     this.pathStack.pushPathByName("Course_Detail", {} as EmptyParams, false);
                      //   });
                      Button('删除')
                        .fontSize(12)
                        .fontColor('#FFFFFF')
                        .width(60)
                        .height(30)
                        .backgroundColor('#FF4D4D') // 红色背景
                        .border({ radius: 10 })
                        .onClick(() => {
                          this.showDeleteDialog(course);
                        })
                        .margin({ right: 10 })
                    }
                    .height(150)
                    .backgroundColor(course.bgColor)
                    .margin({ bottom: 10 })
                    .border({ radius: 10 });

                  }
                  .onClick(() => {
                    AppStorageUtils.setCurrentCourseId(course.courseId);
                    this.pathStack.pushPathByName("Course_Detail", {} as EmptyParams, false);
                  });
                }, (item: CourseWithColor) => item.courseId.toString());
              }
              .width('90%')
              .margin({ bottom: 10, left: 10 });
            }

            // Button('新增课程')
            //   .width('90%')
            //   .height(50)
            //   .fontSize(18)
            //   .backgroundColor('#4CAF50')
            //   .fontColor('#fff')
            //   .borderRadius(10)
            //   .margin({ top: 20, bottom: 20 })
            //   .onClick(() => {
            //     this.pathStack.pushPathByName("Add_Course", {} as EmptyParams, false);
            //   });
          }

          .padding({ left: 10, right: 10 })
        }
      }
    }
    .title('课程管理页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    });

  }
  onWillAppear() {
    // 页面重新显示时刷新数据
    this.courses = [];
    this.fetchCourses();
  }

  aboutToAppear() {
    this.fetchCourses();
  }
  showDeleteDialog(course: ApiCourse) {
    AlertDialog.show({
      title: '确认删除',
      message: `确定要删除课程《"${course.courseName}" 》吗？此操作不可恢复！`,
      primaryButton: {
        value: '取消',
        action: () => {
          // 取消操作
        }
      },
      secondaryButton: {
        value: '确认',
        action: async () => {
          await this.deleteCourse(course.courseId);
        }
      }
    });
  }
  private async fetchCourses() {
    try {
      const res = await courseApi.getMyCourses(1, 10);
      if (res.code === 200 && res.data?.records) {
        this.courses = res.data.records.map((item: ApiCourse) => ({
          courseId: item.courseId,
          courseName: item.courseName,
          description: item.description,
          createTime: item.createTime,
          updateTime: item.updateTime,
          username: item.username,
          courseImg: item.courseImg,
          bgColor: this.getColorById(item.courseId)
        }as CourseWithColor));
      } else {
        console.error('获取课程失败:', res.message);
        this.courses = [];
      }
    } catch (err) {
      console.error('请求异常:', err);
      this.courses = [];
    }
  }
  async deleteCourse(courseId: number) {
    // try {
      const response = await courseApi.deleteCourse(courseId);
      if (response.code === 200) {
        console.info('课程删除成功:', response.message);
        await this.fetchCourses(); // 刷新用户列表
        // this.pathStack.pop();
        // this.pathStack.pushPathByName('Course_Manage',null,false);
      } else {
        console.error(`删除失败: ${response.message}`);
        AlertDialog.show({
          title: '提示',
          message: `删除失败: ${response.message}`,
          primaryButton: {
            value: '确定',
            action: () => {}
          }
        });
      }
    // } catch (error) {
    //   console.error('删除课程异常:', JSON.stringify(error));
    //   AlertDialog.show({
    //     title: '错误',
    //     message: '删除过程中发生错误，请查看日志',
    //     primaryButton: {
    //       value: '确定',
    //       action: () => {}
    //     }
    //   });
    // }
  }

  // loadCourses() {
  //   throw new Error('Method not implemented.');
  // }

  private getColorById(id: number): string {
    const colors = ['#B8E2DC', '#FCEBB5', '#C9E4F3', '#D8F0D1', '#F4C2C2', '#CDE7FF', '#E6F7E6', '#FFFACD'];
    return colors[id % colors.length];
  }
}
