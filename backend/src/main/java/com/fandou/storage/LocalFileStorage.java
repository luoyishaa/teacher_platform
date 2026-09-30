package com.fandou.storage;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@Component
@ConditionalOnProperty(name = "storage.mode", havingValue = "local", matchIfMissing = true)
public class LocalFileStorage implements FileStorage {
    private final Path root;

    public LocalFileStorage(@Value("${storage.local.directory:./.data/files}") String directory) throws IOException {
        root = Path.of(directory).toAbsolutePath().normalize();
        Files.createDirectories(root);
    }

    private Path path(String key) throws IOException {
        if (!key.matches("[0-9a-f]{32}")) throw new IOException("Invalid storage key");
        Path path = root.resolve(key).normalize();
        if (!path.startsWith(root)) throw new IOException("Invalid storage path");
        return path;
    }

    @Override
    public String save(MultipartFile file) throws IOException {
        String key = UUID.randomUUID().toString().replace("-", "");
        Path target = path(key);
        try (InputStream input = file.getInputStream()) {
            Files.copy(input, target);
        } catch (IOException error) {
            Files.deleteIfExists(target);
            throw error;
        }
        return key;
    }

    @Override
    public InputStream open(String key) throws IOException {
        return Files.newInputStream(path(key));
    }

    @Override
    public void delete(String key) throws IOException {
        Files.deleteIfExists(path(key));
    }
}
