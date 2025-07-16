// 跳转页面入口函数

import { AppStorageUtils } from '../utils/AppStorageUtils';
import { UserInfo } from '../types/api';
import { courseApi } from '../api/CourseApi';
import { NavPathInfo, ClassManageParams } from'../types/navigation';
import { Role } from './Role'; // 假设Role页面存在
@Builder
export function Teacher_LayoutBuilder() {
  Teacher_Layout()
}
@Component
struct Teacher_Layout {
  pathStack: NavPathStack = new NavPathStack();
  @State username: string = '加载中...'; // 给一个默认值
  @State role: string = '加载中...';
  @State avatarUrl: string = ''; // 用于存放头像URL
  @State isJumping: boolean = false;

  aboutToAppear() {
    // appstorage，获取当前登录的用户信息
    const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();

    if (currentUser) {
      this.username = currentUser.username;
      this.role = '教师';
      this.avatarUrl = currentUser.avatar;
    } else {
      this.username = '未登录';
      this.role = '游客';
    }
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Image($rawfile('Background_Mainpage.png'))
            .width('100%')
            .height('100%')

          Column() {
            Row() {
              Blank();
              Text('刷新')
                .fontSize(20)
                .fontColor(Color.Grey)
                .fontWeight(FontWeight.Bold)
              Image($rawfile('Update.png'))
                .width(30)
                .height(30)
                .onClick(() => {
                  //TODO:添加更新逻辑
                  const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();

                  if (currentUser) {
                    this.username = currentUser.username;
                    this.role = '教师';
                    this.avatarUrl = currentUser.avatar;
                  } else {
                    this.username = '未登录';
                    this.role = '游客';
                  }
                });
            }
            .margin({ bottom: 5, right: 10 })
            .width('100%');
            Text(this.username)
              .fontSize(27)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10 })
              .width('80%')
              .align(Alignment.Start)
            Row() {
              Text(this.role)
                .fontSize(20)
                .fontColor('#000000')
                .margin({ top: 18, bottom: 20, right: 30 })
                .align(Alignment.Start)
              Image($rawfile('arrow_right.png'))
                .width(30)
                .height(30)
                .margin({ right: 80 })
                .onClick(() => {
                  // this.pathStack.pop();
                  this.pathStack.pushPathByName("Role", null, false);
                })
              // Image($rawfile('pic1.png'))
              //   .width(180)
              //   .align (Alignment.End)
              if (this.avatarUrl && this.avatarUrl !== '') {
                // 如果 avatarUrl 存在且不为空字符串
                Image(this.avatarUrl) // 直接使用网络URL
                  .width(100)
                  .height(100)
                  .border({ radius: 50 })
                  .margin({ right: 6 , bottom: 4})
                  .backgroundColor(Color.White)
                  .align(Alignment.End)
                  .objectFit(ImageFit.Cover) // 添加这个属性可以防止图片拉伸变形
                  .onError(() => {
                    this.avatarUrl = ''; // 加载失败时，可以清空URL，让UI显示默认头像
                  })

              } else {
                // 如果 avatarUrl 为空，则显示本地的默认头像
                Image($rawfile('pic1.png'))
                  .width(180)
                  .align(Alignment.End)
              }
            }
            .margin({ top: 30, bottom: 50 })
            .width('80%')

            Row() {
              Image($rawfile('Class_Manage.png'))
                .width(150)
                .height(150)
                .margin({ top: 20, left: 20, bottom: 10 })

              Text('课程管理')
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 5, left: 20 })
              // .border({ radius: 20, width: 1.5, color: '#000000' })
            }
            .width('80%')
            .height('25%')
            .backgroundColor('#B2DFFC')
            .border({ radius: 20 })
            .margin({ bottom: 20 })
            .onClick(() => {
              this.pathStack.pushPathByName("Course_Manage", null);
            })


            Row() {
              Image($rawfile('Resource-upload.png'))
                .width(150)
                .height(150)
                .margin({ top: 20, left: 20, bottom: 10 })

              Text('资源管理')
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 5, left: 20 })
              // .border({ radius: 20, width: 1.5, color: '#000000' })

            }
            .width('80%')
            .height('25%')
            .backgroundColor('#B2DFFC')
            .border({ radius: 20 })
            .margin({ bottom: 20 })
            .onClick(() => {
              //this.pathStack.pop();
              this.pathStack.pushPathByName("Resource_Upload", null, false);
            })
          }
        }
      }

    }
    .title('教师主页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
  onWillAppear() {
    // appstorage，获取当前登录的用户信息
    const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();

    if (currentUser) {
      this.username = currentUser.username;
      this.role = '教师';
      this.avatarUrl = currentUser.avatar;
    } else {
      this.username = '未登录';
      this.role = '游客';
    }
  }
}