import router from '@ohos.router';
import { authApi } from '../api/AuthApi';
import { AppStorageUtils } from '../utils/AppStorageUtils';
import { RegisterPayload } from '../types/api';
import { promptAction } from '@kit.ArkUI';

// 跳转页面入口函数
@Builder
export function RegisterBuilder() {
  Register()
}
@Component
struct Register {
  pathStack: NavPathStack = new NavPathStack();

  //让ui根据这些变量的变化自动刷新
  @State username: string = '';
  @State password: string = '';
  @State message: string = '';
  @State isLoading: boolean = false;

  build() {
    NavDestination() {
    Stack() {
      Image($rawfile('Background.png'))
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])

      Column() {
        Image($rawfile('Coverage.png'))
          .width(300)
          .height(300)
          .margin({ bottom: 20 })
        Text('用户名')
          .width('80%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 10 })
        TextInput()
          .fontColor(Color.Black)
          .type(InputType.Normal)
          .width(300)
          .backgroundColor(Color.White)
          .border({ radius: 10 })
          .margin({ bottom: 20 })
          .onChange((value:string) => {
            this.username = value; // 保存用户名
          })

        Text('密码')
          .width('80%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 10 })
        TextInput()
          .fontColor(Color.Black)
          .type(InputType.Password)
          .width(300)
          .backgroundColor(Color.White)
          .border({ radius: 10 })
          .margin({ bottom: 30 })
          .onChange((value:string) => {
            this.password = value; // 保存密码
          })
        // Text('忘记密码')
        //   .textAlign(TextAlign.End)
        //   .width('90%')

        Text(this.message)
          .fontColor(Color.Red)
          .fontSize(16)

        Button('登录')
          .fontSize(15)
          .fontColor('#000000')
          .width(250)
          .backgroundColor('#72BFF9')//.fontWeight(FontWeight.Bold)
          .border({ radius: 20 })
          .margin({ bottom: 20 })
          .onClick(() => {
            // this.pathStack.pushPathByName("Admin_Layout", null, false);
            this.handleLogin();
            // if (this.isAdmin(this.username, this.password )) {
            //   this.pathStack.pushPathByName("Admin_Layout", null, false);
            // }
            // else{
            //   this.pathStack.pushPathByName("Layout", null, false);
            // }
          })
          .enabled(!this.isLoading) // 当正在加载时，按钮不可点击
        Button('注册')
          .fontSize(15)
          .fontColor('#000000')
          .width(250)
          .backgroundColor(Color.Transparent)
          .border({ radius: 20, width: 1.5, color: '#000000' })
          .margin({ bottom: 40 })
          .onClick(() => {
            // this.pathStack.pushPathByName("Teacher_Layout", null, false);
            this.handleRegister();
          })

        Text('登录即默认同意用户协议')
          .textAlign(TextAlign.End)
      }
      .width('90%')
      .height('90%')
    }
     .width('100%')
     .height('100%')
     .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
    }
    //.title('登录/注册页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }

  async handleLogin() {
    if (!this.username || !this.password) {
      // this.message = '用户名和密码不能为空';
      promptAction.showToast({ message: '用户名和密码不能为空' });
      return;
    }

    this.isLoading = true;
    // this.message = '正在登录中...';
    promptAction.showToast({ message: '正在登录中...' });


    try {
      const response = await authApi.login({
        username: this.username,
        password: this.password
      });

      if (response.code === 200 && response.data) {
        promptAction.showToast({ message: '登录成功！' });
        setTimeout(() => {

        }, 1200); // 延迟1秒

        AppStorageUtils.setToken(response.data.token);
        AppStorageUtils.setCurrentUser(response.data.userInfo);

        const userRole = response.data.userInfo.role;
        let targetUrl = '';
        switch (userRole) {
          case 'admin':
            // 如果是管理员，跳转到管理员专用的布局或主页
            targetUrl = 'Admin_Layout';
            console.log('用户角色: admin, 跳转到管理员页面...');
            promptAction.showToast({ message: '用户角色: admin, 跳转到管理员页面...' });
            setTimeout(() => {

            }, 1200); // 延迟1秒
            break;
          case 'teacher':
            // 如果是教师，跳转到教师专用的布局或主页
            targetUrl = 'Teacher_Layout';
            console.log('用户角色: teacher, 跳转到教师页面...');
            promptAction.showToast({ message: '用户角色: teacher, 跳转到教师页面...' });
            setTimeout(() => {

            }, 1200); // 延迟1秒
            break;
          default:
            console.error(`未知的用户角色: ${userRole}`);
            targetUrl = 'Register'; // 或者跳转回登录页
            this.message = '无法识别的用户角色';
            this.isLoading = false;
            return;
        }

        // this.message = '跳转页面...';
        // promptAction.showToast({ message: '跳转页面...' });

        // 延迟一小段时间（给用户看成功提示），然后执行跳转
        setTimeout(() => {
          // 使用 router.replaceUrl()，这样用户无法通过“返回”按钮回到登录页
          // router.replaceUrl({ url: targetUrl });
          this.message = '';
          // this.pathStack.pushPathByName(targetUrl, null, false);
          // this.pathStack.clear();
          this.message = '';
          this.pathStack.clear();
          this.pathStack.pushPath({
            name: targetUrl
          });
        }, 1000); // 延迟1秒

      } else {
        promptAction.showToast({ message: response.message });
        // this.message = response.message;
      }
    } catch (error) {
      // this.message = '网络错误，请稍后重试';

      console.error('Login request failed:', JSON.stringify(error));
      promptAction.showToast({ message: '网络错误，请稍后重试' });
      setTimeout(() => {

      }, 1000); // 延迟1秒
      this.message = '';
    } finally {
      this.isLoading = false;
    }
  }

  async handleRegister() {

    if (!this.username || !this.password) {
      // this.message = '用户名和密码不能为空！';
      promptAction.showToast({ message: '用户名和密码不能为空！' });
      setTimeout(() => {

      }, 1000); // 延迟1秒
      return;
    }
    this.message = '';
    this.isLoading = true;
    // this.message = '正在注册...';
    promptAction.showToast({ message: '正在注册...' });
    setTimeout(() => {

    }, 1000); // 延迟1秒
    const payload: RegisterPayload = {
      username: this.username,
      password: this.password,
      role: 'teacher'
    };

    try {
      const response = await authApi.register(payload);

      if (response.code === 200) {
        // this.message = '注册成功！即将跳转到登录页...';
        promptAction.showToast({ message: '注册成功！即将跳转到登录页...' });
        setTimeout(() => {
          if (this.pathStack) {
            this.pathStack.clear();
            this.message = '';
            this.pathStack.pushPath({
              name: "Register"
            });
          } else {
            console.error("PathStack 未初始化，无法跳转！");
          }
        }, 1500);
      } else {
        // this.message = '用户名已存在！';
        promptAction.showToast({ message: '用户名已存在' });
      }
    } catch (error) {
      this.message = '注册请求失败';
      promptAction.showToast({ message: '网络异常，注册请求失败！' });
      console.error(JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }
}
