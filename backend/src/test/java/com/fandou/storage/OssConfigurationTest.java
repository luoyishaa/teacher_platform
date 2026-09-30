package com.fandou.storage;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:oss_test;MODE=MySQL;NON_KEYWORDS=USER;DB_CLOSE_DELAY=-1",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.sql.init.mode=always",
        "jwt.secret=integration-test-secret-32-characters-minimum",
        "storage.mode=oss",
        "aliyun.oss.endpoint=https://oss-cn-chengdu.aliyuncs.com",
        "aliyun.oss.access-key-id=dummy",
        "aliyun.oss.access-key-secret=dummy",
        "aliyun.oss.bucket-name=dummy-bucket"
})
class OssConfigurationTest {
    @Autowired FileStorage storage;

    @Test
    void ossModeSelectsOssAdapterWithoutConnectingToCloud() {
        assertThat(storage).isInstanceOf(OssFileStorage.class);
    }
}
