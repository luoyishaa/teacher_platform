import http from '@ohos.net.http';
import { logApi } from '../api/LogApi';
//import type { ApiResponse } from '../types/api';
import type { UserInfo, ApiResponse, PageResult } from '../types/api'

// 跳转页面入口函数
@Builder
export function Log_RecordingBuilder() {
  Log_Recording()
}

// 页面顶部定义接口
interface LogRecord {
  id: number;
  username: string;
  description: string;
  method: string;
  ip: string;
  createTime: string;
}

interface GeneratedTypeLiteralInterface_1 {
  records: LogRecord[];
}

@Component
struct Log_Recording {
  pathStack: NavPathStack = new NavPathStack();
  @State logRecords: LogRecord[] = [];
  @State pageNum: number = 1;
  @State pageSize: number = 100;
  @State total: number = 0;
  @State isLoading: boolean = true;
  @State errorMessage: string = '';

  aboutToAppear() {
    this.loadLogs();
  }

  // 加载日志数据
  private async loadLogs() {
    try {
      this.isLoading = true;
      const response = await logApi.getOperationLogs(this.pageNum, this.pageSize);

      if (response.code === 200 && response.data) {
        this.logRecords = response.data.records;
        this.total = response.data.total || 0;
      } else {
        this.errorMessage = response.message || '获取日志失败';
        console.error('日志加载失败:', this.errorMessage);
        // 失败时使用模拟数据作为fallback
        this.initMockLogs();
      }
    } catch (err) {
      this.errorMessage = `网络请求异常: ${err.message}`;
      console.error('获取日志列表异常:', JSON.stringify(err));
      // 异常时使用模拟数据作为fallback
      this.initMockLogs();
    } finally {
      this.isLoading = false;
    }
  }

  // 保留原有的模拟数据方法作为fallback
  private initMockLogs() {
    this.logRecords = [
    // ...原有的mock数据...
    ];
  }

  // 时间格式化方法
  private formatTime(isoString: string): string {
    try {
      return new Date(isoString).toLocaleString();
    } catch (e) {
      return isoString; // 解析失败时返回原始字符串
    }
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Image($rawfile('Background_Mainpage.png'))
            .width('100%')
            .height('100%');

          Column() {
            Text('操作日志记录')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .align(Alignment.TopStart)
              .width('100%')
              .padding({ left: 15 })
              .margin({ top: 20 });

            Divider().align(Alignment.TopStart);

            // 加载状态显示
            if (this.isLoading) {
              LoadingProgress()
                .width(50)
                .height(50)
                .margin({ top: 100 });
            }
            // 错误状态显示
            else if (this.errorMessage) {
              Text(this.errorMessage)
                .fontSize(16)
                .fontColor('#FF0000')
                .margin({ top: 100 });
            }
            // 正常数据展示
            else {
              List() {
                ForEach(this.logRecords, (record: LogRecord) => {
                  ListItem() {
                    Column({ space: 8 }) {
                      Row() {
                        Text(`用户：${record.username}`)
                          .fontSize(16)
                          .fontWeight(FontWeight.Bold);
                        Text(record.ip)
                          .fontSize(14)
                          .fontColor('#666')
                          .layoutWeight(1)
                          .textAlign(TextAlign.End);
                      }

                      Text(`操作：${record.description}`)
                        .fontSize(15);

                      Text(`时间：${this.formatTime(record.createTime)}`)
                        .fontSize(13)
                        .fontColor('#999');
                    }
                    .padding({ left: 15, right: 15, top: 10, bottom: 10 })
                    .borderRadius(8)
                    .margin({ bottom: 10, left: 10, right: 10 });
                  }
                  .backgroundColor('#B2DFFC')
                  .margin({ bottom: 10 })
                  .borderRadius(10);
                }, (record: LogRecord) => record.id.toString());
              }
              .width('90%')
              .height('90%')
              .margin({ top: 20 });

              // 分页信息展示
              Row() {
                Text(`第 ${this.pageNum} 页`)
                  .fontSize(14)
                  .margin({ right: 10 });
                Text(`共 ${this.total} 条记录`)
                  .fontSize(14);
              }
              .margin({ top: 10 });
            }
          }
        }
        .padding(10)
        .width('100%');
      }
    }
    .title('操作日志记录')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    });
  }
}
