package com.fandou.storage;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.io.InputStream;

/** Only storage mechanics live behind this seam; ownership belongs to the resource module. */
public interface FileStorage {
    String save(MultipartFile file) throws IOException;
    InputStream open(String key) throws IOException;
    void delete(String key) throws IOException;
}
