// import http from '@ohos.net.http'
// import { userApi } from '../api/UserApi'
// import type { UserInfo, ApiResponse, PageResult} from '../types/api'
// //import { AlertDialog } from '@ohos.components'; // 添加此行以使用弹窗
//
// // 跳转页面入口函数
// @Builder
// export function User_ManageBuilder() {
//   User_Manage()
// }
//
// @Component
// struct User_Manage {
//   pathStack: NavPathStack = new NavPathStack()
//
//   @State users: UserInfo[] = []
//   @State pageNum: number = 1
//   @State pageSize: number = 10
//   @State total: number = 0
//
//   async loadUsers() {
//     try {
//       // 注意这里的类型直接使用接口定义中导入的类型，避免重复定义
//       const response = await userApi.getUsers(this.pageNum, this.pageSize)
//
//       // 类型守卫 + 类型断言（如果你不确定结构完全匹配）
//       if (response && response.code === 200 && response.data && Array.isArray(response.data.records)) {
//         this.users = response.data.records
//         this.total = response.data.total ?? 0 // 防止 total 字段缺失
//       console.info('API返回：', JSON.stringify(response))
//       console.info('用户数组：', this.users.length)
//       } else {
//         console.error(`用户加载失败：${response?.message ?? '未知错误'}`)
//       }
//     } catch (err) {
//       console.error('获取用户列表异常:', JSON.stringify(err))
//     }
//   }
//   showDeleteDialog(user: UserInfo) {
//     AlertDialog.show({
//       title: '确认删除',
//       message: `确定要删除用户 "${user.username}" 吗？此操作不可恢复！`,
//       primaryButton: {
//         value: '取消',
//         action: () => {
//           // 取消操作
//         }
//       },
//       secondaryButton: {
//         value: '确认',
//         action: async () => {
//           await this.deleteUser(user.username);
//         }
//       }
//     });
//   }
//
//   async deleteUser(username: string) {
//     try {
//       const response = await userApi.deleteUserByUsername(username);
//       if (response.code === 200) {
//         console.info('用户删除成功:', response.message);
//         await this.loadUsers(); // 刷新用户列表
//       } else {
//         console.error(`删除失败: ${response.message}`);
//         AlertDialog.show({
//           title: '提示',
//           message: `删除失败: ${response.message}`,
//           primaryButton: {
//             value: '确定',
//             action: () => {}
//           }
//         });
//       }
//     } catch (error) {
//       console.error('删除用户异常:', JSON.stringify(error));
//       AlertDialog.show({
//         title: '错误',
//         message: '删除过程中发生错误，请查看日志',
//         primaryButton: {
//           value: '确定',
//           action: () => {}
//         }
//       });
//     }
//   }
//
//
//   formatTime(isoString: string): string {
//     const date = new Date(isoString)
//     return date.toLocaleString()
//   }
//
//   build() {
//     NavDestination() {
//       Column() {
//         Stack() {
//           Image($rawfile('Background_Mainpage.png'))
//             .width('100%')
//             .height('100%')
//
//           if (this.users.length === 0) {
//             Text('正在加载用户数据...')
//               .fontSize(20)
//               .margin(20)
//           } else {
//             List() {
//               ForEach(this.users, (user: UserInfo) => {
//                 ListItem() {
//                   Row() {
//                     // 头像
//                     Image(user.avatar || $rawfile('pic1.png'))
//                       .width(80)
//                       .height(80)
//                       .border({ radius: 50 })
//                       .margin({ right: 10 })
//                       .backgroundColor(Color.White)
//
//                     // 中间文字
//                     Column() {
//                       Text(`用户名：${user.username}`)
//                         .fontColor(Color.Black)
//                         .fontSize(20)
//                         .width('100%')
//                         .fontWeight(FontWeight.Bold)
//                         .margin({ bottom: 25 })
//
//
//                       Text(`用户角色：${user.role}`)
//                         .fontColor(Color.Gray)
//                         .fontSize(15)
//
//                       Text(`创建时间：${this.formatTime(user.createTime)}`)
//                         .fontColor(Color.Gray)
//                         .fontSize(15)
//                     }
//                     .layoutWeight(1)
//                     .alignItems(HorizontalAlign.Start)
//                     Button('删除')
//                       .fontSize(12)
//                       .fontColor('#FFFFFF')
//                       .width(60)
//                       .height(30)
//                       .backgroundColor('#FF4D4D') // 红色背景
//                       .border({ radius: 10 })
//                       .onClick(() => {
//                         this.showDeleteDialog(user);
//                       })
//                   }
//                   .height(150)
//                   .margin({ bottom: 10 })
//                   .border({ radius: 10 })
//                 }
//                 .backgroundColor('#E6F2FF')
//                 .margin({ bottom: 10 })
//                 // .onClick(() => {
//                 //   this.pathStack.pushPath({
//                 //     name: 'User_Info',
//                 //     param: {
//                 //       username: user.username
//                 //     } satisfies NavParam
//                 //   })
//                 // })
//
//               })
//             }
//             .width('90%')
//             .margin({ bottom: 10, left: 10 })
//           }
//         }
//         .width('100%')
//         .height('100%')
//       }
//        .onAppear(() => {
//          this.loadUsers()
//        })
//     }
//     .title('用户管理页')
//     .onReady((context: NavDestinationContext) => {
//       this.pathStack = context.pathStack
//     })
//   }
// }
import http from '@ohos.net.http'
import { userApi } from '../api/UserApi'
import type { UserInfo, ApiResponse, PageResult} from '../types/api'
//import { AlertDialog } from '@ohos.components'; // 添加此行以使用弹窗

// 跳转页面入口函数
@Builder
export function User_ManageBuilder() {
  User_Manage()
}

@Component
struct User_Manage {
  pathStack: NavPathStack = new NavPathStack()

  @State users: UserInfo[] = []
  @State pageNum: number = 1
  @State pageSize: number = 10
  @State total: number = 0

  async loadUsers() {
    try {
      // 注意这里的类型直接使用接口定义中导入的类型，避免重复定义
      const response = await userApi.getUsers(this.pageNum, this.pageSize)

      // 类型守卫 + 类型断言（如果你不确定结构完全匹配）
      if (response && response.code === 200 && response.data && Array.isArray(response.data.records)) {
        this.users = response.data.records
        this.total = response.data.total ?? 0 // 防止 total 字段缺失
        console.info('API返回：', JSON.stringify(response))
        console.info('用户数组：', this.users.length)
      } else {
        console.error(`用户加载失败：${response?.message ?? '未知错误'}`)
      }
    } catch (err) {
      console.error('获取用户列表异常:', JSON.stringify(err))
    }
  }
  showDeleteDialog(user: UserInfo) {
    AlertDialog.show({
      title: '确认删除',
      message: `确定要删除用户 "${user.username}" 吗？此操作不可恢复！`,
      primaryButton: {
        value: '取消',
        action: () => {
          // 取消操作
        }
      },
      secondaryButton: {
        value: '确认',
        action: async () => {
          await this.deleteUser(user.username);
        }
      }
    });
  }

  async deleteUser(username: string) {
    try {
      const response = await userApi.deleteUserByUsername(username);
      if (response.code === 200) {
        console.info('用户删除成功:', response.message);
        await this.loadUsers(); // 刷新用户列表
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
    } catch (error) {
      console.error('删除用户异常:', JSON.stringify(error));
      AlertDialog.show({
        title: '错误',
        message: '删除过程中发生错误，请查看日志',
        primaryButton: {
          value: '确定',
          action: () => {}
        }
      });
    }
  }


  formatTime(isoString: string): string {
    const date = new Date(isoString)
    return date.toLocaleString()
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Image($rawfile('Background_Mainpage.png'))
            .width('100%')
            .height('100%')
          Column() {

            Text('所有用户')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .align(Alignment.TopStart)
              .width('100%')
              .padding({ left: 15 })
              .margin({ top: 20 ,bottom : 10});

            Divider().align(Alignment.TopStart).margin({ bottom: 10 });


            if (this.users.length === 0) {
              Text('正在加载用户数据...')
                .fontSize(20)
                .margin(20)
            } else {
              List() {
                ForEach(this.users, (user: UserInfo) => {
                  ListItem() {
                    Row() {
                      // 头像
                      Image(user.avatar || $rawfile('pic1.png'))
                        .width(80)
                        .height(80)
                        .border({ radius: 50 })
                        .margin({ right: 10 })
                        .backgroundColor(Color.White)

                      // 中间文字
                      Column() {
                        Text(`用户名：${user.username}`)
                          .fontColor(Color.Black)
                          .fontSize(20)
                          .width('100%')
                          .fontWeight(FontWeight.Bold)
                          .margin({ bottom: 25 })


                        Text(`用户角色：${user.role}`)
                          .fontColor(Color.Gray)
                          .fontSize(15)

                        Text(`创建时间：${this.formatTime(user.createTime)}`)
                          .fontColor(Color.Gray)
                          .fontSize(15)
                      }
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)

                      Button('删除')
                        .fontSize(12)
                        .fontColor('#FFFFFF')
                        .width(60)
                        .height(30)
                        .backgroundColor('#FF4D4D')// 红色背景
                        .border({ radius: 10 })
                        .onClick(() => {
                          this.showDeleteDialog(user);
                        })
                    }
                    .height(150)
                    .margin({ bottom: 10 })
                    .border({ radius: 10 })
                  }
                  .backgroundColor('#E6F2FF')
                  .margin({ bottom: 10 })
                  .borderRadius(10)

                  // .onClick(() => {
                  //   this.pathStack.pushPath({
                  //     name: 'User_Info',
                  //     param: {
                  //       username: user.username
                  //     } satisfies NavParam
                  //   })
                  // })

                })
              }
              .width('90%')
              .margin({ bottom: 10, left: 10 })
            }
          }
          .width('100%')
          .height('100%')
        }
        .onAppear(() => {
          this.loadUsers()
        })
      }
    }
    .title('用户管理页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
