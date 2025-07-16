package com.fandou.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
// @EnableTransactionManagement 声明式事务管理
public class MybatisPlusConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        // 创建一个总的拦截器 MybatisPlusInterceptor
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();

        // 创建并添加分页插件 PaginationInnerInterceptor
        // 需要指定你使用的数据库类型，这里我们用的是MySQL
        PaginationInnerInterceptor paginationInnerInterceptor = new PaginationInnerInterceptor(DbType.MYSQL);

        // 设置当请求的页码大于最大页码时，是否回到第一页
        paginationInnerInterceptor.setOverflow(true);
        // 设置单页查询数量的上限，防止恶意查询，-1表示不限制
        paginationInnerInterceptor.setMaxLimit(500L);

        // 将分页插件添加到总拦截器中
        interceptor.addInnerInterceptor(paginationInnerInterceptor);

        // 乐观锁插件
        // interceptor.addInnerInterceptor(new OptimisticLockerInnerInterceptor());

        return interceptor;
    }
}
