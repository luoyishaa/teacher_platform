package com.fandou.vo;

import lombok.Data;
import lombok.NoArgsConstructor; // Lombok注解，生成一个无参构造函数

import java.io.Serializable;
import java.util.List;

@Data
@NoArgsConstructor
public class PageResult<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 总记录数
     * 例如，数据库中总共有 153 条用户记录
     */
    private Long total;

    /**
     * 当前页的数据列表
     * 例如，当前是第2页，每页10条，这里就存放着第11条到第20条的用户数据
     */
    private List<T> records;

    public PageResult(Long total, List<T> records) {
        this.total = total;
        this.records = records;
    }
}