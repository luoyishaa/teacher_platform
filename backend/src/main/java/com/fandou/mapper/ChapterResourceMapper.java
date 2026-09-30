package com.fandou.mapper;

import com.fandou.vo.AttachedResourceRow;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ChapterResourceMapper {
    @Select("SELECT cr.chapter_id, r.id, r.resource_name, r.create_time, r.size_bytes FROM chapter_resource cr JOIN resource r ON r.id = cr.resource_id JOIN chapter c ON c.chapter_id = cr.chapter_id WHERE c.course_id = #{courseId} ORDER BY r.id")
    List<AttachedResourceRow> listForCourse(@Param("courseId") int courseId);

    @Select("SELECT COUNT(*) FROM chapter_resource WHERE resource_id = #{resourceId}")
    int countByResource(@Param("resourceId") long resourceId);

    @Select("SELECT COUNT(*) FROM chapter_resource WHERE chapter_id = #{chapterId} AND resource_id = #{resourceId}")
    int countPair(@Param("chapterId") int chapterId, @Param("resourceId") long resourceId);

    @Insert("INSERT INTO chapter_resource (chapter_id, resource_id) VALUES (#{chapterId}, #{resourceId})")
    int attach(@Param("chapterId") int chapterId, @Param("resourceId") long resourceId);

    @Delete("DELETE FROM chapter_resource WHERE chapter_id = #{chapterId} AND resource_id = #{resourceId}")
    int detach(@Param("chapterId") int chapterId, @Param("resourceId") long resourceId);
}
