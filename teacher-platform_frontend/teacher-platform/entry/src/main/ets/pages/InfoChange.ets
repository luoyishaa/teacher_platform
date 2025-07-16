import { UserInfo, UserUpdatePayload } from "../types/api";
import { AppStorageUtils } from "../utils/AppStorageUtils";
import { userApi } from '../api/UserApi'; // 导入用户更新API
import { fileApi } from "../api/FileApi";
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import  { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
// 跳转页面入口函数
@Builder
export function InfoChangeBuilder() {
  InfoChange()
}
@Component
struct InfoChange {
  pathStack: NavPathStack = new NavPathStack();
  @State message: string = '';
  @State username: string = '加载中....'
  @State role: string = '加载中....'
  @State password: string = '.............'
  @State isLoading: boolean = false;
  @State previewAvatarUrl: string = '';
  @State newPassword: string = '';
  @State avatar: string = '';

  aboutToAppear() {
    const currentUser: UserInfo | null = AppStorageUtils.getCurrentUser();
    if (currentUser) {
      this.username = currentUser.username;
      this.role = currentUser.role;
      // 初始时，预览头像就是用户当前的头像
      this.previewAvatarUrl = currentUser.avatar;
      this.avatar = currentUser.avatar;
    }
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
        console.info('Simulating call to uploadFile with URI: ' + fileUri);
        promptAction.showToast({ message: '上传成功！' });

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

      // 调用 FileApi 上传
      console.log('准备上传文件:', fileUri, fileName);
      const fileUrl = await fileApi.uploadFile(fileUri, fileName);
      // 这里进行了一个本地url到阿里云的url的转换
      console.log('上传成功，文件 URL:', fileUrl);
      this.previewAvatarUrl = fileUrl;
    } catch (err) {
      console.error('上传失败:', err);
    }
  }

  /**
   * 处理“修改完成”按钮的点击事件
   */
  async handleUpdateProfile() {
    this.isLoading = true;
    this.message = '正在保存用户信息...';

    // 准备要提交的数据
    const payload: UserUpdatePayload = {};
    if (this.newPassword) { // 只有当用户输入了新密码时，才加入payload
      payload.password = this.newPassword;
    }
    // 将最终预览的头像URL加入payload
    payload.avatar = this.previewAvatarUrl;

    // 如果没有任何要更新的，可以直接返回
    if (!payload.password&&payload.avatar==this.avatar) {
      console.log('未做任何修改')
      promptAction.showToast({ message: '未做任何修改' });;
      this.isLoading = false;
      return;
    }else{
      console.log('准备提交数据里的url:', payload.avatar);
    }

    try {
      // 调用更新用户信息的API
      const updateResponse = await userApi.updateUserInfo(this.username, payload);

      if (updateResponse.code === 200 && updateResponse.data) {
        // 更新成功，更新本地AppStorage的用户信息
        AppStorageUtils.setCurrentUser(updateResponse.data);
        // this.message = '信息保存成功！';
        console.log('信息保存成功');
        promptAction.showToast({ message: '信息保存成功' });
        // 延迟后返回上一页
        setTimeout(() => {
          this.pathStack.replacePathByName("Role", null, false)
        }, 1000);

      } else {
        console.log(updateResponse.message);
        promptAction.showToast({ message: '信息保存失败' });
        console.log('信息保存失败');
      }
    } catch (error) {
      // this.message = '保存时发生网络错误';
      console.log('保存时发生网络错误');
      promptAction.showToast({ message: '保存时发生网络错误' });
      console.error("Profile update failed:", JSON.stringify(error));
    } finally {
      this.isLoading = false;
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
            Image(this.previewAvatarUrl ? this.previewAvatarUrl : $rawfile('pic1.png'))
              .width(150)
              .height(150)
              .clip(Circle())
              .onClick(() => {
                this.selectAndUploadFile();
              })
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
            // TextInput({ placeholder: '请输入邮箱', text: this.email })
            //   .fontSize(15)
            //   .type(InputType.Email)
            //   .fontColor('#000000')
            //   .onChange((value: string) => {
            //     this.email = value;
            //   })
            //   .border({ width: 1, color: { top: '#00ffffff', left: '#00ffffff', right: '#00ffffff', bottom: '#000000' } })

            Text('密码')
              .fontSize(20)
              .fontColor('#000000')
              .align(Alignment.Center)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 10 })
              .align(Alignment.Start)
            // TextInput({ placeholder: '请输入新密码', text: this.password })
            TextInput({ placeholder: '请输入新密码(不修改请留空)' })
              .type(InputType.PhoneNumber)
              .fontSize(15)
              .fontColor('#000000')
              .onChange((value: string) => {
                this.newPassword = value; // 更新新密码状态
              })
              .margin({ top: 20 , bottom : 50})
              .border({ width: 1, color: { top: '#00ffffff', left: '#00ffffff', right: '#00ffffff', bottom: '#000000' } })
            // TextInput({ placeholder: '请输入新密码(不修改请留空)' })
            //   .type(InputType.Password)
            //   .onChange((value: string) => {
            //     this.newPassword = value; // 更新新密码状态
            //   })
            Button('修改完成')
              .fontSize(15)
              .fontColor('#000000')
              .width(250)
              .backgroundColor('#72BFF9')//.fontWeight(FontWeight.Bold)
              .border({ radius: 20 })
              .margin({ bottom: 20,top: 30 })
              .onClick(() => {
                this.handleUpdateProfile();
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
    .title('信息修改')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}