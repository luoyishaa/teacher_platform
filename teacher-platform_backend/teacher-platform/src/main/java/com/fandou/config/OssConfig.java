///* 以下注释的是idea自带的阿里云的config
// * Copyright 2013-2018 the original author or authors.
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      https://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//package com.fandou.config;
//
//import com.aliyun.oss.OSS;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.ApplicationRunner;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
///**
// * OSS common config.
// *
// * @author <a href="mailto:chenxilzx1@gmail.com">theonefx</a>
// */
//@Configuration
//public class OssConfig {
//
//    /**
//     * Bucket Name of OSS Example.
//     */
//    public static final String BUCKET_NAME = "spring-cloud-alibaba-test";
//
//    @Autowired
//    private OSS ossClient;
//
//    /**
//     * You can use these code to check or create oss bucket. Or manage buckets in
//     * <a href="https://oss.console.aliyun.com/bucket">oss console</a>.
//     */
//    @Bean
//    public ApplicationRunner ossBucketInitRunner() {
//        return args -> {
//            if (!ossClient.doesBucketExist(BUCKET_NAME)) {
//                ossClient.createBucket(BUCKET_NAME);
//            }
//        };
//    }
//}

package com.fandou.config;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OssConfig {

    // 从我们自定义的配置路径中读取信息
    @Value("${aliyun.oss.endpoint}")
    private String endpoint;

    @Value("${aliyun.oss.access-key-id}")
    private String accessKeyId;

    @Value("${aliyun.oss.access-key-secret}")
    private String accessKeySecret;

    /**
     * 手动创建一个OSS客户端Bean，并放入Spring容器
     * @return 配置好的OSS客户端实例
     */
    @Bean
    public OSS ossClient() {
        // 这是创建OSS客户端的标准方式
        return new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
    }
}


