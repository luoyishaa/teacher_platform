package com;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:teacher_test;MODE=MySQL;NON_KEYWORDS=USER;DB_CLOSE_DELAY=-1",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.sql.init.mode=always",
        "storage.local.directory=./target/test-files",
        "jwt.secret=integration-test-secret-32-characters-minimum"
})
@AutoConfigureMockMvc
class WorkspaceIntegrationTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;

    private JsonNode body(MvcResult result) throws Exception {
        return json.readTree(result.getResponse().getContentAsString());
    }

    private String registerAndLogin(String name) throws Exception {
        mvc.perform(post("/auth/register").contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"" + name + "\",\"password\":\"Password123!\",\"role\":\"teacher\"}"))
                .andExpect(status().isOk());
        return body(mvc.perform(post("/auth/login").contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"" + name + "\",\"password\":\"Password123!\"}"))
                .andExpect(status().isOk()).andReturn()).path("data").path("token").asText();
    }

    @Test
    void teacherCanReuseOwnFileButCannotAccessAnotherTeachersCourseOrFile() throws Exception {
        String alice = registerAndLogin("alice");
        String bob = registerAndLogin("bob");
        String a = "Bearer " + alice;
        String b = "Bearer " + bob;
        mvc.perform(get("/courses")).andExpect(status().isUnauthorized());

        int course = body(mvc.perform(post("/courses").header("Authorization", a)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"courseName\":\"Algorithms\",\"description\":\"Basics\"}"))
                .andExpect(status().isOk()).andReturn()).path("data").path("courseId").asInt();
        int chapter = body(mvc.perform(post("/courses/{id}/chapters", course).header("Authorization", a)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"chapterName\":\"Lists\"}"))
                .andExpect(status().isOk()).andReturn()).path("data").path("chapterId").asInt();
        MockMultipartFile file = new MockMultipartFile("file", "notes.txt", "text/plain", "lesson notes".getBytes());
        long resource = body(mvc.perform(multipart("/resources").file(file).header("Authorization", a))
                .andExpect(status().isOk()).andReturn()).path("data").path("id").asLong();

        mvc.perform(post("/courses/{course}/chapters/{chapter}/resources", course, chapter)
                .header("Authorization", a).contentType(MediaType.APPLICATION_JSON)
                .content("{\"resourceId\":" + resource + "}")).andExpect(status().isOk());
        JsonNode chapterList = body(mvc.perform(get("/courses/{course}/chapters", course)
                .header("Authorization", a)).andExpect(status().isOk()).andReturn());
        assertThat(chapterList.path("data").path("records").get(0).path("resources").get(0)
                .path("resourceName").asText()).isEqualTo("notes.txt");
        assertThat(mvc.perform(get("/resources/{id}/content", resource).header("Authorization", a))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsByteArray())
                .isEqualTo("lesson notes".getBytes());

        mvc.perform(get("/courses/{course}/chapters", course).header("Authorization", b))
                .andExpect(status().isForbidden());
        mvc.perform(get("/resources/{id}/content", resource).header("Authorization", b))
                .andExpect(status().isForbidden());
        mvc.perform(post("/courses/{course}/chapters/{chapter}/resources", course, chapter)
                .header("Authorization", b).contentType(MediaType.APPLICATION_JSON)
                .content("{\"resourceId\":" + resource + "}")).andExpect(status().isForbidden());
        int bCourse = body(mvc.perform(post("/courses").header("Authorization", b)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"courseName\":\"Bob course\"}"))
                .andExpect(status().isOk()).andReturn()).path("data").path("courseId").asInt();
        int bChapter = body(mvc.perform(post("/courses/{id}/chapters", bCourse).header("Authorization", b)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"chapterName\":\"Bob chapter\"}"))
                .andExpect(status().isOk()).andReturn()).path("data").path("chapterId").asInt();
        mvc.perform(post("/courses/{course}/chapters/{chapter}/resources", bCourse, bChapter)
                .header("Authorization", b).contentType(MediaType.APPLICATION_JSON)
                .content("{\"resourceId\":" + resource + "}")).andExpect(status().isForbidden());
        mvc.perform(post("/courses/{course}/chapters/{chapter}/resources", course, chapter)
                .header("Authorization", a).contentType(MediaType.APPLICATION_JSON)
                .content("{\"resourceId\":" + resource + "}")).andExpect(status().isConflict());
        mvc.perform(delete("/resources/{id}", resource).header("Authorization", a))
                .andExpect(status().isConflict());
        mvc.perform(delete("/courses/{course}/chapters/{chapter}/resources/{resource}",
                course, chapter, resource).header("Authorization", a)).andExpect(status().isOk());
        mvc.perform(delete("/resources/{id}", resource).header("Authorization", a))
                .andExpect(status().isOk());
        mvc.perform(get("/resources/{id}/content", resource).header("Authorization", a))
                .andExpect(status().isNotFound());
        try (var files = Files.list(Path.of("./target/test-files"))) {
            assertThat(files.count()).isZero();
        }
    }
}
