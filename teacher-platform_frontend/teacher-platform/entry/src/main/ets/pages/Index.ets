@Entry
@Component

struct Index {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
    }.onAppear(() => {
      this.pathStack.pushPathByName("Register", null, false); //跳转
    })
    .hideNavBar(true) //不会把自己放到控制跳转的对象里面 → 点返回的时候不会返回到这个导航页
  }
}



    //课程组件
  //   Column(){
  //     Text('猜你喜欢')
  //       .fontColor('#fff')
  //       .width('100%')
  //       .margin({bottom:10})
  //     List(){
  //       ListItem(){
  //         Row(){
  //           //图
  //           Image($rawfile('pic1.png'))
  //             .height('70%')
  //             .border({radius:8})
  //             .margin({right:10})
  //           //文字
  //           Column(){
  //             Text('英语课')
  //               .fontColor(Color.Black)
  //               .fontSize(20)
  //               .width('100%')
  //               .fontWeight(700)
  //               .margin({bottom:25})
  //             Text('depart')
  //               .padding({ top: 3, bottom: 3, left: 5, right: 5 })
  //               .border({width:1,color:Color.Black,radius:12})
  //               .margin({bottom:10,left:1})
  //             Text(' name')
  //           }
  //            .layoutWeight(1)
  //            .alignItems(HorizontalAlign.Start)
  //           //更多
  //           Image($rawfile('ArrowToRight.png'))
  //             .width(20)
  //
  //         }
  //          .width('100%')
  //          .height(150)
  //          .backgroundColor('#B8E2DC')
  //          .margin({bottom:10})
  //          .border({radius:10})
  //       }
  //
  //       ListItem(){
  //         Row(){
  //           //图
  //           Image($rawfile('pic1.png'))
  //             .height('70%')
  //             .border({radius:8})
  //             .margin({right:10})
  //           //文字
  //           Column(){
  //             Text('英语课')
  //               .fontColor(Color.Black)
  //               .fontSize(20)
  //               .width('100%')
  //               .fontWeight(700)
  //               .margin({bottom:25})
  //             Text('depart')
  //               .padding({ top: 3, bottom: 3, left: 5, right: 5 })
  //               .border({width:1,color:Color.Black,radius:12})
  //               .margin({bottom:10,left:1})
  //             Text(' name')
  //           }
  //           .layoutWeight(1)
  //           .alignItems(HorizontalAlign.Start)
  //           //更多
  //           Image($rawfile('ArrowToRight.png'))
  //             .width(20)
  //         }
  //         .width('100%')
  //         .height(150)
  //         .backgroundColor('#FFF5BA')
  //         .margin({bottom:10})
  //         .border({radius:10})
  //       }
  //
  //       ListItem(){
  //         Row(){
  //           //图
  //           Image($rawfile('pic1.png'))
  //             .height('70%')
  //             .border({radius:8})
  //             .margin({right:10})
  //           //文字
  //           Column(){
  //             Text('英语课')
  //               .fontColor(Color.Black)
  //               .fontSize(20)
  //               .width('100%')
  //               .fontWeight(700)
  //               .margin({bottom:25})
  //             Text('depart')
  //               .padding({ top: 3, bottom: 3, left: 5, right: 5 })
  //               .border({width:1,color:Color.Black,radius:12})
  //               .margin({bottom:10,left:1})
  //             Text(' name')
  //           }
  //           .layoutWeight(1)
  //           .alignItems(HorizontalAlign.Start)
  //           //更多
  //           Image($rawfile('ArrowToRight.png'))
  //             .width(20)
  //
  //         }
  //         .width('100%')
  //         .height(150)
  //         .backgroundColor('#E6DAF0')
  //         .margin({bottom:10})
  //         .border({radius:10})
  //       }
  //
  //       ListItem(){
  //         Row(){
  //           //图
  //           Image($rawfile('pic1.png'))
  //             .height('70%')
  //             .border({radius:8})
  //             .margin({right:10})
  //           //文字
  //           Column(){
  //             Text('英语课')
  //               .fontColor(Color.Black)
  //               .fontSize(20)
  //               .width('100%')
  //               .fontWeight(700)
  //               .margin({bottom:25})
  //             Text('depart')
  //               .padding({ top: 3, bottom: 3, left: 5, right: 5 })
  //               .border({width:1,color:Color.Black,radius:12})
  //               .margin({bottom:10,left:1})
  //             Text(' name')
  //           }
  //           .layoutWeight(1)
  //           .alignItems(HorizontalAlign.Start)
  //           //更多
  //           Image($rawfile('ArrowToRight.png'))
  //             .width(20)
  //
  //         }
  //         .width('100%')
  //         .height(150)
  //         .backgroundColor('#FFE0B2')
  //         .margin({bottom:10})
  //         .border({radius:10})
  //       }
  //
  //       ListItem(){
  //         Row(){
  //           //图
  //           Image($rawfile('pic1.png'))
  //             .height('70%')
  //             .border({radius:8})
  //             .margin({right:10})
  //           //文字
  //           Column(){
  //             Text('英语课')
  //               .fontColor(Color.Black)
  //               .fontSize(20)
  //               .width('100%')
  //               .fontWeight(700)
  //               .margin({bottom:25})
  //             Text('depart')
  //               .padding({ top: 3, bottom: 3, left: 5, right: 5 })
  //               .border({width:1,color:Color.Black,radius:12})
  //               .margin({bottom:10,left:1})
  //             Text(' name')
  //           }
  //           .layoutWeight(1)
  //           .alignItems(HorizontalAlign.Start)
  //           //更多
  //           Image($rawfile('ArrowToRight.png'))
  //             .width(20)
  //
  //         }
  //         .width('100%')
  //         .height(150)
  //         .backgroundColor('#FFF9F0')
  //         .margin({bottom:10})
  //         .border({radius:10})
  //       }
  //
  //     }
  //
  //   }
  //    .width('100%')
  //    .height('100%')
  //    .backgroundColor('#131313')
  //    .padding({left:10,right:10})
  //    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
  // }
  //}

// struct Index {
//   @State message: string = 'Hello World';
//
//   build() {
//     RelativeContainer() {
//       Text(this.message)
//         .id('HelloWorld')
//         .fontSize(50)
//         .fontWeight(FontWeight.Bold)
//         .alignRules({
//           center: { anchor: '__container__', align: VerticalAlign.Center },
//           middle: { anchor: '__container__', align: HorizontalAlign.Center }
//         })
//     }
//     .height('100%')
//     .width('100%')
//   }
//