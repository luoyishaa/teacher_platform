import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
// 新加入了权限
import type { Permissions } from '@ohos.abilityAccessCtrl';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
const PERMISSIONS: Array<Permissions> = ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.INTERNET', 'ohos.permission.GET_NETWORK_INFO']

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }
  // async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
  //   let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
  //   try {
  //     await atManager.requestPermissionsFromUser(this.context, PERMISSIONS);
  //     AppStorage.SetOrCreate('filePath', this.context.filesDir)
  //     AppStorage.SetOrCreate('context', this.context)
  //     console.info('appstart' + 'MainAbility onCreate')
  //   } catch (err) {
  //     console.info('appstart' + `err: ${JSON.stringify(err)}`)
  //   }
  // }




  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }


}