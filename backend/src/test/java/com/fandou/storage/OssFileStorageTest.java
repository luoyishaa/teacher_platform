package com.fandou.storage;

import com.aliyun.oss.OSS;
import com.aliyun.oss.model.OSSObject;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class OssFileStorageTest {
    @Test
    void delegatesUploadDownloadAndDeletionToOssClient() throws Exception {
        OSS client = mock(OSS.class);
        OssFileStorage storage = new OssFileStorage(client, "test-bucket");
        String key = storage.save(new MockMultipartFile("file", "notes.txt", "text/plain", "notes".getBytes()));
        assertThat(key).matches("[0-9a-f]{32}");
        verify(client).putObject(eq("test-bucket"), eq(key), any(InputStream.class));

        OSSObject object = new OSSObject();
        object.setObjectContent(new ByteArrayInputStream("notes".getBytes()));
        when(client.getObject("test-bucket", key)).thenReturn(object);
        try (InputStream content = storage.open(key)) {
            assertThat(content.readAllBytes()).isEqualTo("notes".getBytes());
        }

        storage.delete(key);
        verify(client).deleteObject("test-bucket", key);
        storage.close();
        verify(client).shutdown();
    }
}
