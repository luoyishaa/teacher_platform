package com.fandou.vo;

import com.fandou.entity.Chapter;
import lombok.Data;
import java.util.ArrayList;
import java.util.List;

@Data
public class ChapterView {
    private Integer chapterId;
    private String chapterName;
    private String description;
    private List<AttachedResourceRow> resources = new ArrayList<>();

    public ChapterView(Chapter chapter) {
        chapterId = chapter.getChapterId();
        chapterName = chapter.getChapterName();
        description = chapter.getDescription();
    }
}
