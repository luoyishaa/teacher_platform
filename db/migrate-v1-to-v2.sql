USE `teacher_platform_db`;

-- Run once against a database created by the previous schema.sql.
ALTER TABLE `resource`
    MODIFY COLUMN `file_url` VARCHAR(512) NULL,
    ADD COLUMN `storage_key` VARCHAR(512) NULL,
    ADD COLUMN `content_type` VARCHAR(255) NOT NULL DEFAULT 'application/octet-stream',
    ADD COLUMN `size_bytes` BIGINT NOT NULL DEFAULT 0;

-- Existing OSS records keep their URL. New uploads use storage_key.
CREATE TABLE `chapter_resource` (
    `chapter_id` INT NOT NULL,
    `resource_id` BIGINT NOT NULL,
    PRIMARY KEY (`chapter_id`, `resource_id`),
    KEY `idx_chapter_resource_resource` (`resource_id`),
    CONSTRAINT `fk_chapter_resource_chapter` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`chapter_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_chapter_resource_resource` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
