// import { chapterApi } from '../api/ChapterApi';
// import { Chapter } from '../types/api';
// import { AppStorageUtils } from '../utils/AppStorageUtils';
//
// @Builder
// export function Course_DetailBuilder() {
//   Course_Detail();
// }
//
// interface EmptyParams {}
//
// @Component
// struct Course_Detail {
//   @State chapters: Chapter[] = [];
//   @State isLoading: boolean = true;
//   @State errorMessage: string = '';
//   @State courseId: number = -1;
//   pathStack: NavPathStack = new NavPathStack();
//   @State pageNum: number = 1;
//   @State pageSize: number = 10;
//   @State totalPages: number = 0;
//   @State hasMoreData: boolean = true;
//
//   build() {
//     NavDestination() {
//       Column() {
//         Stack() {
//           Image($rawfile('Background_Mainpage.png')).width('100%').height('100%');
//
//           Column() {
//             Row() {
//               Blank();
//               Text('创建新章节')
//                 .fontSize(20)
//                 .fontColor('#000000')
//                 .fontWeight(FontWeight.Bold)
//                 .margin({ top: 5 });
//               Image($rawfile('Add.png'))
//                 .width(30)
//                 .height(30)
//                 .onClick(() => {
//                   this.pathStack.pushPathByName("Add_Chapter", {} as EmptyParams, false);
//                 });
//             }
//             .margin({ bottom: 20, right: 10 })
//             .width('100%');
//
//             Text('课程章节')
//               .fontSize(24)
//               .fontWeight(FontWeight.Bold)
//               .margin({ top: 20, bottom: 20 });
//
//             Text(`课程ID: ${this.courseId}`)
//               .fontSize(14)
//               .fontColor(Color.Gray)
//               .margin({ bottom: 10 });
//
//             if (this.isLoading && this.pageNum === 1) {
//               LoadingProgress().width(50).height(50).margin({ top: 30 });
//             } else if (this.errorMessage) {
//               Text(this.errorMessage)
//                 .fontSize(16)
//                 .fontColor(Color.Red)
//                 .margin({ top: 20 });
//               Button('重新加载')
//                 .onClick(() => {
//                   this.pageNum = 1;
//                   this.chapters = [];
//                   this.fetchChapters();
//                 })
//                 .margin({ top: 10 });
//             } else if (this.chapters.length === 0 && !this.isLoading) {
//               Text('暂无章节内容')
//                 .fontSize(16)
//                 .fontColor(Color.Gray)
//                 .margin({ top: 20 });
//             } else {
//               List() {
//                 ForEach(
//                   this.chapters,
//                   (chapter: Chapter) => {
//                     ListItem() {
//                       Column() {
//                         Text(chapter.chapterName)
//                           .fontSize(20)
//                           .fontWeight(FontWeight.Bold)
//                           .fontColor(Color.Black)
//                           .margin({ bottom: 5 });
//
//                         if (chapter.video) {
//                           Row() {
//                             Image($rawfile('video_icon.png')).width(20).height(20);
//                             Text('视频章节')
//                               .fontSize(14)
//                               .fontColor(Color.Gray);
//                           };
//                         }
//                       }
//                       .padding(15)
//                       .backgroundColor('#E6F2FF')
//                       .border({ radius: 10 })
//                       .margin({ bottom: 12 })
//                       .width('100%')
//                       .onClick(() => {
//                         console.info('点击了章节，跳转到 Chapter_Detail');
//                         // AppStorageUtils.setCurrentChapterId(chapter.chapterId);
//                         AppStorageUtils.setCurrentChapterId(chapter.chapterId);
//                         AppStorageUtils.setCurrentVideoUrl(chapter.video);
//                         this.pathStack.pushPathByName("Chapter_Detail", null, false);
//                       });
//                     }
//                   },
//                   (item: Chapter) => item.chapterId.toString()
//                 );
//
//                 if (this.hasMoreData) {
//                   ListItem() {
//                     Button(this.isLoading ? '加载中...' : '加载更多')
//                       .width('100%')
//                       .backgroundColor(Color.White)
//                       .onClick(() => this.loadMore());
//                   };
//                 }
//
//                 if (!this.hasMoreData && this.chapters.length > 0) {
//                   ListItem() {
//                     Text('没有更多章节了')
//                       .fontSize(14)
//                       .fontColor(Color.Gray)
//                       .textAlign(TextAlign.Center)
//                       .width('100%');
//                   };
//                 }
//               }
//               .width('90%')
//               .margin({ bottom: 20 })
//               .onReachEnd(() => this.loadMore());
//             }
//           }
//         }
//       }
//     }
//     .title('课程详情页')
//     .onReady((context: NavDestinationContext) => {
//       const storedCourseId = AppStorageUtils.getCurrentCourseId();
//       if (storedCourseId !== null && storedCourseId > 0) {
//         this.courseId = storedCourseId;
//         this.pageNum = 1;
//         this.chapters = [];
//         this.fetchChapters();
//       } else {
//         this.errorMessage = '未获取到有效的课程ID';
//         this.isLoading = false;
//       }
//       this.pathStack = context.pathStack;
//     });
//   }
//
//   onWillAppear() {
//     // 页面重新显示时刷新数据
//     this.pageNum = 1;
//     this.chapters = [];
//     this.fetchChapters();
//   }
//
//   private async fetchChapters() {
//     try {
//       this.isLoading = true;
//       this.errorMessage = '';
//
//       const result = await chapterApi.getChaptersByCourseId(this.courseId, this.pageNum, this.pageSize);
//
//       if (result.code === 200 && result.data?.records) {
//         this.chapters = [...this.chapters, ...result.data.records];
//         this.totalPages = Math.ceil(Number(result.data.total) / this.pageSize);
//         this.hasMoreData = this.pageNum < this.totalPages;
//       } else {
//         this.errorMessage = result.message || '获取章节列表失败';
//       }
//     } catch (err) {
//       console.error('网络请求失败:', err);
//       this.errorMessage = '网络请求失败，请重试';
//     } finally {
//       this.isLoading = false;
//     }
//   }
//
//   private loadMore() {
//     if (this.hasMoreData && !this.isLoading) {
//       this.pageNum += 1;
//       this.fetchChapters();
//     }
//   }
// }

import { chapterApi } from '../api/ChapterApi';
import { Chapter } from '../types/api';
import { AppStorageUtils } from '../utils/AppStorageUtils';

@Builder
export function Course_DetailBuilder() {
  Course_Detail();
}

interface EmptyParams {}

@Component
struct Course_Detail {
  @State chapters: Chapter[] = [];
  @State isLoading: boolean = true;
  @State errorMessage: string = '';
  @State courseId: number = -1;
  pathStack: NavPathStack = new NavPathStack();
  @State pageNum: number = 1;
  @State pageSize: number = 10;
  @State totalPages: number = 0;
  @State hasMoreData: boolean = true;

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Image($rawfile('Background_Mainpage.png')).width('100%').height('100%');

          Column() {
            Row() {
              Blank();
              Text('创建新章节')
                .fontSize(20)
                .fontColor('#000000')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 5 });
              Image($rawfile('Add.png'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.pathStack.pushPathByName("Add_Chapter", {} as EmptyParams, false);
                });
            }
            .margin({ bottom: 20, right: 10 })
            .width('100%');

            Text('课程章节')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 20 });

            Text(`课程ID: ${this.courseId}`)
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 });

            if (this.isLoading && this.pageNum === 1) {
              LoadingProgress().width(50).height(50).margin({ top: 30 });
            } else if (this.errorMessage) {
              Text(this.errorMessage)
                .fontSize(16)
                .fontColor(Color.Red)
                .margin({ top: 20 });
              Button('重新加载')
                .onClick(() => {
                  this.pageNum = 1;
                  this.chapters = [];
                  this.fetchChapters();
                })
                .margin({ top: 10 });
            } else if (this.chapters.length === 0 && !this.isLoading) {
              Text('暂无章节内容')
                .fontSize(16)
                .fontColor(Color.Gray)
                .margin({ top: 20 });
            } else {
              List() {
                ForEach(
                  this.chapters,
                  (chapter: Chapter) => {
                    ListItem() {
                      Row(){
                        Column() {
                          Text(chapter.chapterName)
                            .fontSize(20)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.Black)
                            .margin({ bottom: 5 });

                          if (chapter.video) {
                            Row() {
                              Image($rawfile('video_icon.png')).width(20).height(20);
                              Text('视频章节')
                                .fontSize(14)
                                .fontColor(Color.Gray);
                            };
                          }
                        }
                        Blank();
                        Button('删除')
                          .fontSize(12)
                          .fontColor('#FFFFFF')
                          .width(60)
                          .height(30)
                          .backgroundColor('#FF4D4D') // 红色背景
                          .border({ radius: 10 })
                          .onClick(() => {
                            this.showDeleteDialog(chapter);
                          })
                      }
                      .padding(15)
                      .backgroundColor('#E6F2FF')
                      .border({ radius: 10 })
                      .margin({ bottom: 12 })
                      .width('100%')
                      .onClick(() => {
                        console.info('点击了章节，跳转到 Chapter_Detail');
                        // AppStorageUtils.setCurrentChapterId(chapter.chapterId);
                        AppStorageUtils.setCurrentChapterName(chapter.chapterName);
                        AppStorageUtils.setCurrentChapterDes(chapter.description);
                        AppStorageUtils.setCurrentVideoUrl(chapter.video);
                        this.pathStack.pushPathByName("Chapter_Detail", null, false);
                      });
                    }
                  },
                  (item: Chapter) => item.chapterId.toString()
                );

                if (this.hasMoreData) {
                  ListItem() {
                    Button(this.isLoading ? '加载中...' : '加载更多')
                      .width('100%')
                      .backgroundColor(Color.White)
                      .onClick(() => this.loadMore());
                  };
                }

                if (!this.hasMoreData && this.chapters.length > 0) {
                  ListItem() {
                    Text('没有更多章节了')
                      .fontSize(14)
                      .fontColor(Color.Gray)
                      .textAlign(TextAlign.Center)
                      .width('100%');
                  };
                }
              }
              .width('90%')
              .margin({ bottom: 20 })
              .onReachEnd(() => this.loadMore());
            }
          }
        }
      }
    }
    .title('课程详情页')
    .onReady((context: NavDestinationContext) => {
      const storedCourseId = AppStorageUtils.getCurrentCourseId();
      if (storedCourseId !== null && storedCourseId > 0) {
        this.courseId = storedCourseId;
        this.pageNum = 1;
        this.chapters = [];
        this.fetchChapters();
      } else {
        this.errorMessage = '未获取到有效的课程ID';
        this.isLoading = false;
      }
      this.pathStack = context.pathStack;
    });
  }

  onWillAppear() {
    // 页面重新显示时刷新数据
    this.chapters= [];
    this.fetchChapters();
  }

  private async fetchChapters() {
    try {
      // this.isLoading = true;
      this.errorMessage = '';

      const result = await chapterApi.getChaptersByCourseId(this.courseId, this.pageNum, this.pageSize);

      if (result.code === 200 && result.data?.records) {
        this.chapters = [...this.chapters, ...result.data.records];
        console.log(this.chapters.toString());
        this.totalPages = Math.ceil(Number(result.data.total) / this.pageSize);
        this.hasMoreData = this.pageNum < this.totalPages;
      } else {
        this.errorMessage = result.message || '获取章节列表失败';
      }
    } catch (err) {
      console.error('网络请求失败:', err);
      this.errorMessage = '网络请求失败，请重试';
    } finally {
      this.isLoading = false;
      this.pathStack.pop();
      this.pathStack.pushPathByName('Course_Detail',null,false);
    }
  }
  showDeleteDialog(chapter: Chapter) {
    AlertDialog.show({
      title: '确认删除',
      message: `确定要删除章节《"${chapter.chapterName}"》吗？此操作不可恢复！`,
      primaryButton: {
        value: '取消',
        action: () => {
          // 取消操作
        }
      },
      secondaryButton: {
        value: '确认',
        action: async () => {
          await this.deleteChapter(chapter.chapterId);
        }
      }
    });
  }
  async deleteChapter(chapterId: number) {
    try {
      const storedCourseId = AppStorageUtils.getCurrentCourseId();
      const response = await chapterApi.deleteChapter(storedCourseId,chapterId);
      if (response.code === 200) {
        console.info('章节删除成功:', response.message);
        this.pageNum = 1;
        this.chapters = []; // 清空当前数据
        await this.fetchChapters(); // 重新拉取最新数据
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
      console.error('删除章节异常:', JSON.stringify(error));
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

  private loadMore() {
    if (this.hasMoreData && !this.isLoading) {
      this.pageNum += 1;
      this.fetchChapters();
    }
  }
}

