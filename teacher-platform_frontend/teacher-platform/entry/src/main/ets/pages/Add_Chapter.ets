import router from '@ohos.router'
import { common } from '@kit.AbilityKit';
import { picker } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileApi } from '../api/FileApi';
import { chapterApi } from '../api/ChapterApi';
import { AppStorageUtils } from '../utils/AppStorageUtils';

// 跳转页面入口函数
@Builder
export function Add_ChapterBuilder() {
  Add_Chapter()
}

// 定义课程数据结构类型
interface Chapter {
  chapterId: number;
  courseId: number;
  chapterName: string;
  description: string;
  createTime: string | null;
  video: string;
  ppt: string;
}

@Component
struct Add_Chapter {
  pathStack: NavPathStack = new NavPathStack();

  @State chapterName: string = '';
  @State description: string = '';
  @State courseImg: Resource = $rawfile('pic1.png'); // 默认图片
  @State video: string='';

  async selectAndUploadFile() {
    try {
      // 获取 UIAbilityContext，这是必须的
      let context = getContext(this) as common.UIAbilityContext;

      // 创建 DocumentViewPicker 实例，传入 context
      let documentPicker = new picker.DocumentViewPicker(context);

      // 配置选择选项，这里我们限制只能选择一个文件
      let documentSelectOptions = new picker.DocumentSelectOptions();
      // documentSelectOptions.selectNumber = 1;

      // 调用 select 并用 await 等待用户选择结果
      promptAction.showToast({ message: '请选择文件...' });
      const uris: Array<string> = await documentPicker.select(documentSelectOptions);

      // 检查用户是否已选择文件
      if (uris && uris.length > 0) {
        const fileUri = uris[0]; // 获取选择的第一个文件的URI
        console.info(`File selected successfully. URI: ${fileUri}`);

        // 调用上传函数
        promptAction.showToast({ message: '正在上传...' });
        await this.uploadFile(fileUri);
      } else {
        console.info('User canceled the file selection.');
        promptAction.showToast({ message: '已取消选择' });
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error(`File selection or upload failed. Code: ${err.code}, Message: ${err.message}`);
      promptAction.showToast({ message: `操作失败: ${err.message}` });
    }
  }

  async submitFile() {
    const newChapter: Chapter = {
      chapterId: Math.floor(Math.random() * 1000), // 模拟生成 chapterId
      courseId: 1,
      chapterName: this.chapterName,
      description: this.description,
      createTime: new Date().toISOString(), // 当前时间
      video: this.video, // 可选，暂留空或通过其他方式设置
      ppt: '' // 可选，暂留空或通过其他方式设置
    };
    const storedCourseId = AppStorageUtils.getCurrentCourseId();
    const response = await chapterApi.createChapter(storedCourseId, newChapter);
    console.info('新增章节:', JSON.stringify(newChapter));
    this.pathStack.pop();
    this.pathStack.replacePathByName("Course_Detail", null, false);
    // 返回上一页，并携带数据
    router.back({
      url: 'pages/Course_Detail', // 返回的目标页面
      params: {
        newChapter: JSON.stringify(newChapter)
      }
    });
  }

  async uploadFile(fileUri: string) {
    try {
      // 从 URI 中提取文件名 (e.g., 'image.jpg')
      const fileName = fileUri.split('/').pop() || 'default_name';

      // 调用 ResourceApi 上传资源
      console.log('准备上传资源:', fileUri, fileName);
      const response = await fileApi.uploadFile(fileUri, fileName);

      if (response) {
        const resource = response;
        console.log('资源URL:', resource);
        this.video = resource;
        promptAction.showToast({ message: `上传成功: ${response}` });

        // 可选：跳转或刷新列表
        // router.back(); // 返回上一页
      } else {
        promptAction.showToast({ message: `上传失败: ${response}` });
      }
    } catch (err) {
      console.error('上传失败:', err);
      promptAction.showToast({ message: `上传异常: ${err instanceof Error ? err.message : '未知错误'}` });
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
            // 页面标题
            Text('创建新章节')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20, bottom: 30 })

            // 课程名称输入框
            TextInput({ placeholder: '请输入章节名称' })
              .onChange((value: string) => {
                this.chapterName = value;
              })
              .width('90%')
              .height(50)
              .fontSize(16)
              .border({ color: '#ccc', width: 1, radius: 8 })
              .padding({ left: 10 })

            // 课程描述输入框
            TextInput({ placeholder: '请输入章节描述' })
              .onChange((value: string) => {
                this.description = value;
              })
              .width('90%')
              .height(100)
              .fontSize(16)
              .border({ color: '#ccc', width: 1, radius: 8 })
              .padding({ left: 10 })
              .margin({ top: 20 })

            // 视频上传按钮
            Button('上传视频')
              .onClick(() => {
                this.selectAndUploadFile();

              })
              .width('90%')
              .fontSize(18)
              .backgroundColor('#72BFF9')
              .fontColor('#333')
              .borderRadius(10)
              .margin({ top: 10 })
              .margin({ top: 10 })

            // 提交按钮
            Button('提交')
              .fontSize(18)
              .backgroundColor('#72BFF9')
              .width('90%')
              .margin({top: 30})
              .onClick(() => {
                this.submitFile();
              })
            // 取消按钮
            Button('取消')
              .onClick(() => {
                this.pathStack.pop();
              })
              .width('90%')
              .fontSize(18)
              .backgroundColor('#E0E0E0')
              .fontColor('#333')
              .borderRadius(10)
              .margin({ top: 10 })

            //TODO: 加入上传ppt和视频的功能
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
        }
      }
    }
    .title('创建新章节页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}