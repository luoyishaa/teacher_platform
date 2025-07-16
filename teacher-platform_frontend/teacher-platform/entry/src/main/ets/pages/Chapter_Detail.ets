// import router from '@ohos.router';
//
// // 跳转页面入口函数
// @Builder
// export function Chapter_DetailBuilder() {
//   Chapter_Detail()
// }
//
// // 定义章节数据结构
// interface Chapter {
//   chapterId: number;
//   courseId: number;
//   chapterName: string;
//   description: string;
//   createTime: string | null;
//   video: string;
//   ppt: string;
// }
//
// @Component
// struct Chapter_Detail {
//   pathStack: NavPathStack = new NavPathStack()
//   @State chapters: Array<Chapter> = [
//     {
//       chapterId: 1,
//       courseId: 1,
//       chapterName: '第一章 绪论',
//       description: '介绍课程背景与学习目标',
//       createTime: '2023-05-01',
//       video: 'http://christinabucket.oss-cn-chengdu.aliyuncs.com/2025/07/15/ea8486eb872f4a038526f280e015af05_b359eff02cf0c8d546c50ec779403e62.mp4',
//       ppt: 'https://example.com/ppt1.pptx'
//     }
//   ]
//   @State currentChapter: Chapter = this.chapters[0]
//   webController: WebController = new WebController()
//
//   private openPPTFile() {
//     const pptUrl = this.currentChapter.ppt;
//
//     if (!pptUrl) {
//       AlertDialog.show({ message: '文件路径为空' });
//       return;
//     }
//
//     try {
//       router.pushUrl({
//         url: 'pages/BlankPage', // 一个空页面路径，用于触发 intent
//         params: {
//           want: {
//             action: 'ohos.want.action.viewData',
//             uri: pptUrl,
//             type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation' // PPTX MIME 类型
//           }
//         }
//       });
//     } catch (error) {
//       console.error('打开 PPT 失败:', error);
//       AlertDialog.show({message: '无法打开该文件，请确认设备是否安装了支持的应用'});
//     }
//   }
//
//   build() {
//     NavDestination() {
//       Column() {
//         Stack() {
//           Image($rawfile('Background_Mainpage.png'))
//             .width('100%')
//             .height('100%')
//           Column() {
//             // 章节标题
//             Text(this.currentChapter.chapterName)
//               .fontSize(24)
//               .fontWeight(FontWeight.Bold)
//               .width('100%')
//               .textAlign(TextAlign.Center)
//               .margin({ top: 20, bottom: 10 })
//
//             // 描述
//             Text('章节描述')
//               .fontSize(18)
//               .fontWeight(FontWeight.Bold)
//               .margin({ left: 20, bottom: 5 })
//
//             Text(this.currentChapter.description)
//               .fontSize(16)
//               .fontColor('#333')
//               .width('90%')
//               .margin({ left: 20, right: 20, bottom: 20 })
//               .textAlign(TextAlign.Center)
//
//             // 视频区域
//             Text('视频')
//               .fontSize(18)
//               .fontWeight(FontWeight.Bold)
//               .margin({ left: 20, bottom: 5 })
//
//             Video({ src: this.currentChapter.video })
//               .width('90%')
//               .height(200)
//               .objectFit(ImageFit.Contain)
//               .margin({ left: 20, right: 20, bottom: 20 })
//
//             // // TODO:PPT 区域（可作为资源标识或文本展示）
//             // Text('PPT')
//             //   .fontSize(18)
//             //   .fontWeight(FontWeight.Bold)
//             //   .margin({ left: 20, bottom: 5 })
//             //
//             // Text(this.currentChapter.ppt)
//             //   .fontSize(16)
//             //   .fontColor('#555')
//             //   .width('90%')
//             //   .margin({ left: 20, right: 20 })
//             //   .gesture(
//             //     TapGesture()
//             //       .onAction(() => {
//             //         this.openPPTFile()
//             //       })
//             //   )
//
//             // 返回按钮
//             Button('返回')
//               .onClick(() => {
//                 this.pathStack.pop()
//               })
//               .width('90%')
//               .height(50)
//               .fontSize(16)
//               .backgroundColor('#E6F2FF')
//               .fontColor(Color.Black)
//               .borderRadius(10)
//               .margin({ bottom: 20 ,top: 20})
//           }
//           .width('100%')
//           .height('100%')
//         }
//           }
//     }
//     .title('章节详情页')
//     .onReady((context: NavDestinationContext) => {
//       this.pathStack = context.pathStack;
//     })
//   }
// }
import { AppStorageUtils } from '../utils/AppStorageUtils';
import { Chapter } from '../types/api';
import http from '@ohos.net.http';
import { BASE_URL } from '../api/BaseApi';
import { ApiResponse } from '../types/api';


@Builder
export function Chapter_DetailBuilder() {
  Chapter_Detail();
}

// 跳转参数类型定义
interface EmptyParams {}

@Component
struct Chapter_Detail {
  // @State chapter: Chapter | null = null;
  @State video_url:string='';
  @State chapter_name:string='';
  @State isLoading: boolean = true;
  @State errorMessage: string = '';
  @State chapter_description:string='';
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        // 加载中
        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 30 });
        }
        // // 错误信息
        // else if (this.errorMessage) {
        //   Text(this.errorMessage)
        //     .fontSize(16)
        //     .fontColor(Color.Red)
        //     .margin({ top: 20 });
        //   Button('重新加载')
        //     .onClick(() => this.fetchChapterDetails())
        //     .margin({ top: 10 });
        // }

        // 显示章节详情
        Column() {
          Text(`章节：${this.chapter_name}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 });

          // TDDO: 章节详情
          Text(`章节详情：${this.chapter_description}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 });

          // Text(`视频地址：${this.video_url}`)
          //   .fontSize(16)
          //   .margin({ bottom: 20 });

          Video({ src: this.video_url })
            .width('90%')
            .height(200)
            .objectFit(ImageFit.Contain)
            .margin({ left: 20, right: 20, bottom: 20 })

          // // 修改信息按钮（可选）
          // Button('修改信息')
          //   .width('80%')
          //   .height(40)
          //   .fontSize(16)
          //   .backgroundColor('#4CAF50')
          //   .fontColor('#fff')
          //   .borderRadius(10)
          //   .margin({ top: 20 })
          //   .onClick(() => {
          //     console.info('跳转到编辑页面');
          //     this.pathStack.pushPathByName("Edit_Chapter", {} as EmptyParams, false);
          //   });
        }
        .width('90%')
        .alignItems(HorizontalAlign.Center);

        // 返回按钮
        Button('返回')
          .width('80%')
          .height(40)
          .fontSize(16)
          .backgroundColor('#72BFF9')
          .fontColor(Color.Black)
          .borderRadius(10)
          .margin({ top: 20 })
          .onClick(() => {
            this.pathStack.pop();
          });
      }
      .padding(10)
    }
    .title('章节详情')
    // .onReady(() => {
    //   console.info('Chapter_Detail 页面已就绪，开始加载数据');
    //   this.fetchChapterDetails();
    // });
    .onReady((context: NavDestinationContext) => {
      const storedChapterName = AppStorageUtils.getCurrentChapterName();
      const storedVideoUrl= AppStorageUtils.getCurrentVideoUrl();
      const storeChapterDes=AppStorageUtils.getCurrentChapterDes();
      if (storedChapterName !== null) {
        this.chapter_name= storedChapterName;
        this.video_url= storedVideoUrl;
        this.isLoading = false;
        this.chapter_description=storeChapterDes;
      } else {
        this.errorMessage = '未获取到有效的章节';
        this.isLoading = false;
      }
      this.pathStack = context.pathStack;
    });
  }

}
