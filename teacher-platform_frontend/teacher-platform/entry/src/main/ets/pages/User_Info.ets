// 跳转页面入口函数
@Builder
export function User_InfoBuilder() {
  User_Info()
}

interface UserInfo {
  id: number | null;
  username: string;
  password: string;
  role: string;
  createTime: string;
  avatar: string | null;
}

interface UserCardItem {
  token: string;
  userInfo: UserInfo;
}

@Component
struct User_Info {
  pathStack: NavPathStack = new NavPathStack();
  @State email: string = '';
  @State phoneNumber: string = '';
  @Prop user: UserCardItem = {
    token: '',
    userInfo: {
      id: null,
      username: '',
      password: '',
      role: '',
      createTime: '',
      avatar: null
    }
  };

  build() {
    NavDestination() {
      Stack() {
        Image($rawfile('Background_Mainpage.png'))
          .width('100%')
          .height('100%')
        //TODO: 改正代码，目前无法显示上一页传来的信息。
        // TODO:完善用户信息显示

        Column() {
          Row() {
            Image(this.user.userInfo.avatar) // 显示用户头像
              .width(100)
              .height(100)
              .borderRadius(50)
              .margin({ right: 20 })
            Text(this.user.userInfo.username) // 显示用户名
              .fontSize(20)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, left: 30, bottom: 10 })
          }
          Text(this.user.userInfo.role) // 显示角色
            .fontSize(20)
            .fontColor('#000000')
            .margin({ top: 20, left: 30 })
          Text(this.user.userInfo.password) // 显示密码
            .fontSize(20)
            .fontColor('#000000')
            .margin({ top: 20, left: 30 })
          Text(this.user.userInfo.createTime) // 显示密码
            .fontSize(20)
            .fontColor('#000000')
            .margin({ top: 20, left: 30 })
          Button('修改用户信息')
            .fontSize(15)
            .fontColor('#000000')
            .width(250)
            .backgroundColor('#72BFF9')
            .border({ radius: 20 })
            .margin({ bottom: 20,top: 30 })
            .onClick(() => {
              this.pathStack.pushPathByName("InfoChange_byAdmin", null, false)
            })


        }
      }
    }
    .title('个人信息_用户管理员视角')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
