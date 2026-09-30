package com.fandou.storage;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import jakarta.annotation.PreDestroy;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

@Component
@ConditionalOnProperty(name = "storage.mode", havingValue = "oss")
public class OssFileStorage implements FileStorage {
    private final OSS client;
    private final String bucket;

    @Autowired
    public OssFileStorage(@Value("${aliyun.oss.endpoint}") String endpoint,
                          @Value("${aliyun.oss.access-key-id}") String accessKeyId,
                          @Value("${aliyun.oss.access-key-secret}") String accessKeySecret,
                          @Value("${aliyun.oss.bucket-name}") String bucket) {
        this.client = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
        this.bucket = bucket;
    }

    OssFileStorage(OSS client, String bucket) {
        this.client = client;
        this.bucket = bucket;
    }

    @Override
    public String save(MultipartFile file) throws IOException {
        String key = UUID.randomUUID().toString().replace("-", "");
        try (InputStream input = file.getInputStream()) {
            client.putObject(bucket, key, input);
            return key;
        } catch (RuntimeException error) {
            throw new IOException("OSS upload failed", error);
        }
    }

    @Override
    public InputStream open(String key) throws IOException {
        try { return client.getObject(bucket, key).getObjectContent(); }
        catch (RuntimeException error) { throw new IOException("OSS download failed", error); }
    }

    @Override
    public void delete(String key) throws IOException {
        try { client.deleteObject(bucket, key); }
        catch (RuntimeException error) { throw new IOException("OSS deletion failed", error); }
    }

    @PreDestroy
    public void close() { client.shutdown(); }
}
