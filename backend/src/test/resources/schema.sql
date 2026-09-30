CREATE TABLE `user` (id BIGINT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, role VARCHAR(64) NOT NULL, create_time DATETIME, avatar VARCHAR(512));
CREATE TABLE course (course_id INT AUTO_INCREMENT PRIMARY KEY, course_name VARCHAR(255) NOT NULL,
    description VARCHAR(512), create_time DATETIME, update_time DATETIME, username VARCHAR(255) NOT NULL,
    course_coverimage VARCHAR(512));
CREATE TABLE chapter (chapter_id INT AUTO_INCREMENT PRIMARY KEY, course_id INT NOT NULL, chapter_name VARCHAR(255) NOT NULL,
    description VARCHAR(512), create_time DATETIME, video VARCHAR(512), ppt VARCHAR(512));
CREATE TABLE resource (id BIGINT AUTO_INCREMENT PRIMARY KEY, file_url VARCHAR(512), create_time DATETIME,
    uploader_name VARCHAR(255) NOT NULL, resource_name VARCHAR(255), storage_key VARCHAR(512) NOT NULL,
    content_type VARCHAR(255), size_bytes BIGINT);
CREATE TABLE chapter_resource (chapter_id INT NOT NULL, resource_id BIGINT NOT NULL,
    PRIMARY KEY (chapter_id, resource_id),
    FOREIGN KEY (chapter_id) REFERENCES chapter(chapter_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resource(id));
CREATE TABLE operation_log (id BIGINT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255), description VARCHAR(255),
    method VARCHAR(512), ip VARCHAR(64), create_time DATETIME);
