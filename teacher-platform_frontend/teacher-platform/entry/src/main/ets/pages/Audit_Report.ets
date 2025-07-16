// 跳转页面入口函数
@Builder
export function Audit_ReportBuilder() {
  Audit_Report()
}


@Component
struct Audit_Report {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {}
    .title('审计报表查看')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}