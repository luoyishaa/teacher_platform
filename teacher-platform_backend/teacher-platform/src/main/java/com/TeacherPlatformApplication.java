package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@MapperScan("com.fandou.mapper") // 告诉MyBatis-Plus去哪里找Mapper接口
public class TeacherPlatformApplication {

    public static void main(String[] args) {
        SpringApplication.run(TeacherPlatformApplication.class, args);
    }

}
