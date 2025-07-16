import { UserInfo } from "../types/api";
import { AppStorageUtils } from "../utils/AppStorageUtils";

// 跳转页面入口函数
@Builder
export function RoleBuilder() {
  Role()
}


@Component
export struct Role {
  pathStack: NavPathStack = new NavPathStack();
  // @State email: string = '';
  @State message: string = '';
  @State username:string='加载中....'
  @State role:string='加载中....'
  @State password:string='......................'
  @State avatarUrl:string='加载中....'

  aboutToAppear() {
    // appstorage，获取当前登录的用户信息
    const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();

    if (currentUser) {
      this.username = currentUser.username;
      this.role = currentUser.role;
      this.avatarUrl = currentUser.avatar;
    } else {
      this.username = '未登录';
      this.role = '游客';
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Image($rawfile('Background_Mainpage.png'))
          .width('100%')
          .height('100%')

        Column() {
          Blank().height('10%')
          Row() {
            Image(this.avatarUrl ? this.avatarUrl : $rawfile('pic1.png'))
              .width(100)
              .height(100)
              .border({ radius: 50 })
              .margin({ right: 10 })
              .backgroundColor(Color.White)

            Column() {
              Text(this.username)
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 20, left: 30, bottom: 10 })
              Text(this.role)
                .fontSize(20)
                .fontColor('#000000')
                .margin({ top: 20, left: 30 })
            }
          }
          .margin({ bottom: 50 })
          .border({ radius: 20, color: '#6789CA', width:1.5 })
          .padding({ top: 15, bottom: 15, left: 25, right: 25 })


          Column() {
            // Text('邮箱')
            //   .fontSize(20)
            //   .fontColor('#000000')
            //   .align(Alignment.Center)
            //   .fontWeight(FontWeight.Bold)
            //   .margin({ top: 20, left: 30, bottom: 10 })
            //   .align(Alignment.Start)
            // Text(this.email)
            //   .fontSize(15)
            //   .fontColor('#000000')
            //   .width('100%')
            //   .padding({ left: 10 })
            //   .border({ width: 1, color: { top: '#00ffffff', left: '#00ffffff', right: '#00ffffff', bottom: '#000000' } })
            //   .margin({ top: 20 })

            Text('密码')
              .fontSize(20)
              .fontColor('#000000')
              .align(Alignment.Center)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 10 })
              .align(Alignment.Start)
            Text(this.password)
              .fontSize(30)
              .fontColor('#000000')
              .width('100%')
              .padding({ left: 50 })
              // .align(Alignment.Center)
              .border({ width: 1, color: { top: '#00ffffff', left: '#00ffffff', right: '#00ffffff', bottom: '#000000' } })
              .margin({ top: 20 })

            Button('修改个人信息')
              .fontSize(15)
              .fontColor('#000000')
              .width(250)
              .backgroundColor('#72BFF9')//.fontWeight(FontWeight.Bold)
              .border({ radius: 20 })
              .margin({ bottom: 20,top: 30 })
              .onClick(() => {
                this.pathStack.pop();
                this.pathStack.pushPathByName("InfoChange", null, false);
          })



            Button('退出登录')
              .fontSize(15)
              .fontColor('#000000')
              .width(250)
              .backgroundColor('#72BFF9')//.fontWeight(FontWeight.Bold)
              .border({ radius: 20 })
              .margin({ bottom: 20,top: 30 })
              .onClick(() => {
                // TODO:白条退出
                // this.pathStack.pop()
                this.pathStack.clear();
                this.pathStack.replacePathByName("Register", null, false)
                // this.pathStack.pop();
                // this.message = '';
                // this.pathStack.pushPath({
                //   name: 'Register'
                // });
              })


          }
           .width('80%')
           .margin({ top: 60 })
           .align(Alignment.Start)
        }
         .width('85%')
         .height('98%')
      }

    }
    .title('个人信息')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
  onWillAppear() {
    // 页面重新显示时刷新数据
    // appstorage，获取当前登录的用户信息
    const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();

    if (currentUser) {
      this.username = currentUser.username;
      this.role = currentUser.role;
      this.avatarUrl = currentUser.avatar;
    } else {
      this.username = '未登录';
      this.role = '游客';
    }
  }
}