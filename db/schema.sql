-- ============================================================
-- 智能化在线教学支持服务平台 · 教师中心系统
-- 数据库建表脚本（MySQL 5.7 及以上）
--
-- 说明：建库、建表语句使用 IF NOT EXISTS，
-- 可以在已经建过表的库上重复执行，不会清空或覆盖已有数据。
-- ============================================================

CREATE DATABASE IF NOT EXISTS `teacher_platform_db`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `teacher_platform_db`;

-- ------------------------------------------------------------
-- 用户表
-- 角色以字符串保存，后端启动时把它映射为 Spring Security 的 ROLE_xxx 权限
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户主键',
    `username`    VARCHAR(255) NOT NULL COMMENT '登录名',
    `password`    VARCHAR(255) NOT NULL COMMENT 'BCrypt 加盐哈希后的口令，不存明文',
    `role`        VARCHAR(64)  NOT NULL DEFAULT 'teacher' COMMENT '角色：admin / teacher / student',
    `create_time` DATETIME              DEFAULT NULL COMMENT '注册时间',
    `avatar`      VARCHAR(512)          DEFAULT NULL COMMENT '头像文件地址',
    PRIMARY KEY (`id`),
    -- 用户名加唯一约束：注册时虽然做了查重，但并发下仍可能插入重复账号，靠数据库兜底
    UNIQUE KEY `uk_user_username` (`username`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='用户表';

-- ------------------------------------------------------------
-- 课程表
-- 一个教师可以创建多门课程，用 username 关联创建者
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `course` (
    `course_id`         INT          NOT NULL AUTO_INCREMENT COMMENT '课程主键',
    `course_name`       VARCHAR(255) NOT NULL COMMENT '课程名称',
    `description`       VARCHAR(512)          DEFAULT NULL COMMENT '课程描述',
    `create_time`       DATETIME              DEFAULT NULL COMMENT '创建时间，由后端自动填充',
    `username`          VARCHAR(255) NOT NULL COMMENT '创建者用户名',
    `course_coverimage` VARCHAR(512)          DEFAULT NULL COMMENT '课程封面地址',
    `update_time`       DATETIME              DEFAULT NULL COMMENT '更新时间，由后端自动填充',
    PRIMARY KEY (`course_id`),
    KEY `idx_course_username` (`username`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='课程表';

-- ------------------------------------------------------------
-- 课程章节表
-- 章节必须归属于某个课程，删除课程时连同章节一起删除
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `chapter` (
    `chapter_id`   INT          NOT NULL AUTO_INCREMENT COMMENT '章节主键',
    `course_id`    INT          NOT NULL COMMENT '所属课程',
    `chapter_name` VARCHAR(255) NOT NULL COMMENT '章节名称',
    `description`  VARCHAR(512)          DEFAULT NULL COMMENT '章节描述',
    `create_time`  DATETIME              DEFAULT NULL COMMENT '创建时间，由后端自动填充',
    `video`        VARCHAR(512)          DEFAULT NULL COMMENT '章节视频地址',
    `ppt`          VARCHAR(512)          DEFAULT NULL COMMENT '章节课件地址',
    PRIMARY KEY (`chapter_id`),
    KEY `idx_chapter_course` (`course_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='课程章节表';

-- ------------------------------------------------------------
-- 个人资源表
-- 记录对象存储上的文件与上传者的对应关系，删除时据此清理物理文件
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `resource` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '资源主键',
    `file_url`      VARCHAR(512) DEFAULT NULL COMMENT '旧版本兼容字段',
    `create_time`   DATETIME              DEFAULT NULL COMMENT '上传时间',
    `uploader_name` VARCHAR(255) NOT NULL COMMENT '上传者用户名',
    `resource_name` VARCHAR(255)          DEFAULT NULL COMMENT '原始文件名',
    `storage_key`   VARCHAR(512) NOT NULL COMMENT '存储系统内的对象标识',
    `content_type`  VARCHAR(255) NOT NULL DEFAULT 'application/octet-stream',
    `size_bytes`    BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_resource_uploader` (`uploader_name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='个人资源表';

CREATE TABLE IF NOT EXISTS `chapter_resource` (
    `chapter_id` INT NOT NULL,
    `resource_id` BIGINT NOT NULL,
    PRIMARY KEY (`chapter_id`, `resource_id`),
    KEY `idx_chapter_resource_resource` (`resource_id`),
    CONSTRAINT `fk_chapter_resource_chapter` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`chapter_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_chapter_resource_resource` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='章节引用的资源';

-- ------------------------------------------------------------
-- 操作日志表
-- 由 AOP 切面在标注了 @Log 的方法成功执行后写入
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `operation_log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '日志主键',
    `username`    VARCHAR(255)          DEFAULT NULL COMMENT '操作人',
    `description` VARCHAR(255)          DEFAULT NULL COMMENT '操作描述，来自注解声明',
    `method`      VARCHAR(512)          DEFAULT NULL COMMENT '目标类名与方法名',
    `ip`          VARCHAR(64)           DEFAULT NULL COMMENT '客户端 IP',
    `create_time` DATETIME              DEFAULT NULL COMMENT '操作时间',
    PRIMARY KEY (`id`),
    KEY `idx_log_username` (`username`),
    KEY `idx_log_create_time` (`create_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='操作日志表';
