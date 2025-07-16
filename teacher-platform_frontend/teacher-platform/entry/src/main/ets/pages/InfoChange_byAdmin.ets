// 跳转页面入口函数
@Builder
export function InfoChange_byAdminBuilder() {
  InfoChange_byAdmin()
}

@Component
struct InfoChange_byAdmin {
  pathStack: NavPathStack = new NavPathStack();
  @State username: string = '';
  @State password: string = '';
  @State avatar: string = '';
  @State role: string = '';

  build() {
    NavDestination() {
      Stack() {
        Image($rawfile('Background_Mainpage.png'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])

        Column() {
          Blank().height('10%')
          Row() {
            Image($rawfile(this.avatar))
              .width(150)
              .onClick(()=>{
                //TODO：修改头像
              })
            Column() {
              TextInput({placeholder:'输入新用户名'})
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .width('50%')
                .margin({ top: 20, left: 3, bottom: 10, right:20 })
                .onChange((value: string) => {
                this.username = value; // 更新用户名状态
              })


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
            Text('密码')
              .fontSize(20)
              .fontColor('#000000')
              .align(Alignment.Center)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, left: 30, bottom: 10 })
              .align(Alignment.Start)
            TextInput({ placeholder: '请输入新密码', text: this.password })
              .fontSize(15)
              .type(InputType.Email)
              .fontColor('#000000')
              .onChange((value: string) => {
                this.password = value;
              })
              .border({ width: 1, color: { top: '#00ffffff', left: '#00ffffff', right: '#00ffffff', bottom: '#000000' } })

            Button('修改完成')
              .fontSize(15)
              .fontColor('#000000')
              .width(250)
              .backgroundColor('#72BFF9')//.fontWeight(FontWeight.Bold)
              .border({ radius: 20 })
              .margin({ bottom: 20,top: 30 })
              .onClick(() => {
                this.pathStack.pop()
              })
          }
          .width('80%')
          .margin({ top: 60 })
          .align(Alignment.Start)

        }
        .width('85%')
        .height('98%')
      }
      .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
    }
    .title('信息修改_系统管理员')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}