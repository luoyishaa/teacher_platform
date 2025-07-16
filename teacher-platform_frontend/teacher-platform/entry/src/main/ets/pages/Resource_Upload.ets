// ResourceListPage.ets
import { resourceApi,Resource } from '../api/ResourceApi';
import router from '@ohos.router'
import { common } from '@kit.AbilityKit';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import  { picker } from '@kit.CoreFileKit';
import { fileApi } from "../api/FileApi";

@Builder
export function Resource_UploadBuilder() {
  Resource_Upload()
}
interface GeneratedTypeLiteralInterface_1 {
  records: Resource[];
}
@Entry
@Component
struct Resource_Upload {
  pathStack: NavPathStack = new NavPathStack()
  @State resources: Resource[] = []
  @State isLoading: boolean = true
  @State errorMessage: string = ''
  @State total: number = 0

  aboutToAppear() {
    this.loadResources()
  }

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

  async uploadFile(fileUri: string) {
    try {
      // 从 URI 中提取文件名 (e.g., 'image.jpg')
      const fileName = fileUri.split('/').pop() || 'default_name';

      // 调用 ResourceApi 上传资源
      console.log('准备上传资源:', fileUri, fileName);
      const response = await resourceApi.uploadResource(fileUri, fileName);

      if (response && (response.code === 200 || response.code === 0)) {
        const resource = response.data;
        console.log('上传成功，资源ID:', resource.id);
        console.log('资源URL:', resource.fileUrl);

        // 可选：跳转或刷新列表
        // router.back(); // 返回上一页
        this.loadResources(); // 刷新资源列表
      } else {
        promptAction.showToast({ message: `上传失败: ${response.message}` });
      }
    } catch (err) {
      console.error('上传失败:', err);
      promptAction.showToast({ message: `上传异常: ${err instanceof Error ? err.message : '未知错误'}` });
    }
  }

  // 加载资源列表
  private async loadResources() {
    try {
      console.log('开始加载资源...');
      this.isLoading = true;
      this.errorMessage = '';

      const response = await resourceApi.getResources();
      console.log('完整API响应:', JSON.stringify(response));
      this.total = response.data.total || 0;

      if (response?.code === 200 && response.data) {
        let resources = response.data.records;//获取total和records（data）
        console.log('解析到的资源:', resources);

        // 确保是数组
        this.resources = Array.isArray(resources) ? resources : [];
        console.log('最终资源数量:', response.data.total);
      } else {
        this.errorMessage = response?.message || '获取资源列表失败';
      }
    } catch (error) {
      console.error('加载资源异常:', error);
      this.errorMessage = '网络请求异常';
    } finally {
      this.isLoading = false;
    }
  }

  // 格式化时间显示
  private formatTime(isoString: string): string {
    try {
      return new Date(isoString).toLocaleString()
    } catch (e) {
      return isoString
    }
  }


  build() {
    NavDestination() {
      Column() {
        // Text(`调试信息:${this.total}总数`)
        //   .fontColor('#FF0000')
        //   .fontSize(16)
        Stack() {
          // 背景图
          Image($rawfile('Background_Mainpage.png'))
            .width('100%')
            .height('100%')
          Column(){
          Row() {
            Blank()
            Text('创建新资源')
              .fontSize(20)
              .fontColor('#000000')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 5 })
            Image($rawfile('Add.png'))
              .width(30)
              .height(30)//.margin({ right :10} )
              .onClick(() => {
                this.selectAndUploadFile();
              })
          }
          .margin({ bottom: 20, right: 10 })
          .width('100%')
            .align(Alignment.Top)
            Blank()
          Column() {
            // 标题
            Text('所有资源')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 15 })
              .width('100%')
              .textAlign(TextAlign.Center)

            // 错误提示
            if (this.errorMessage) {
              Text(this.errorMessage)
                .fontSize(16)
                .fontColor('#FF0000')
                .margin({ bottom: 10 })
                .textAlign(TextAlign.Center)
            }

            // 加载状态
            if (this.isLoading) {
              LoadingProgress()
                .width(50)
                .height(50)
                .margin({ top: 50 })
            }
            // 资源列表
            else if (this.total > 0) {
              List() {
                ForEach(this.resources, (resource: Resource) => {
                  ListItem() {
                    Row() {
                      Column() {
                        // 文件名
                        Text(resource.resourceName)
                          .fontSize(18)
                          .fontColor(Color.Black)
                          .fontWeight(FontWeight.Medium)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })

                        // 上传时间
                        Text(`上传时间: ${this.formatTime(resource.createTime)}`)
                          .fontSize(14)
                          .fontColor('#666')
                      }
                      .layoutWeight(1)
                    }
                    .width('100%')
                    .height(80)
                    .padding(10)
                  }
                  .borderRadius(10)
                  .backgroundColor('#F5F5F5')
                  .margin({ bottom: 10 })
                  .onClick(() => {{
                    router.pushUrl({
                      url: 'pages/Resource_Upload'
                    })
                  }})
                })
              }
              .width('90%')
              .height('80%')
              .margin({ top: 10 })
            }
            // 空状态
            else {
              Text('暂无教学资源')
                .fontSize(18)
                .fontColor('#999')
                .margin({ top: 50 })
            }
          }
          .width('100%')
        }
      }
    }
    }
    .title('资源列表')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
