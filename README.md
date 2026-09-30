# 备课间

一个面向教师的课程与备课资料管理网页。教师可以创建课程、编排章节，把上传到个人资源库的文件加入章节；同一份资料可以在多个章节使用。

## 能做什么

- 注册并登录教师账号，管理自己的课程和章节。
- 上传、下载和删除个人资料；将一份资料加入或移出课程章节。
- 按账号隔离数据。访问别人的课程、章节或文件会被拒绝。
- 已被章节引用的资料不能直接删除；移除章节引用不会删除资源库中的文件。
- 后端提供管理员用户管理与操作日志接口，网页聚焦教师工作台。

## 本地运行

需要 JDK 17 或更新版本、Maven 3.6.3 或更新版本、Node.js 22.18 或更新版本，以及 Docker Desktop。前后端分别启动，开发时网页通过 Vite 代理访问后端。

1. 在仓库根目录启动 MySQL：

   ```powershell
   docker compose up -d db
   ```

   首次启动时，容器会用 [db/schema.sql](db/schema.sql) 建表。数据库只监听本机的 `33306` 端口，Compose 中的账号和口令仅供本地开发。

2. 在一个 PowerShell 终端启动后端：

   ```powershell
   $env:DB_PORT = "33306"
   $env:DB_USERNAME = "teacher"
   $env:DB_PASSWORD = "local-teacher-only"
   $env:JWT_SECRET = "replace-this-with-a-random-secret-of-at-least-32-bytes"
   cd backend
   mvn spring-boot:run
   ```

3. 在另一个终端启动网页：

   ```powershell
   cd frontend
   npm ci
   npm run dev
   ```

   打开终端输出的本地地址，注册教师账号即可开始使用。默认文件保存在 `backend/.data/files`，数据库和上传文件都不会提交到 Git。

## 技术实现

网页使用 React、TypeScript 和 Vite；后端使用 Spring Boot 3.5、Spring Security、MyBatis-Plus 与 MySQL。认证采用 JWT，请求中的身份和数据库中的资料归属共同决定能否操作。章节与资料是独立记录，通过 `chapter_resource` 关联，数据库外键约束保证引用的完整性。

文件存储支持本地磁盘和阿里云 OSS，默认使用本地磁盘。若使用 OSS，设置 `STORAGE_MODE=oss`，并提供 `OSS_ENDPOINT`、`OSS_BUCKET_NAME`、`OSS_ACCESS_KEY_ID`、`OSS_ACCESS_KEY_SECRET`。

在 `backend` 运行 `mvn test` 可执行后端测试；在 `frontend` 运行 `npm run build` 可生成网页生产构建。
