package com.fandou.aop;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自定义操作日志记录注解
 */
@Target(ElementType.METHOD) // 定义这个注解可以贴在哪里：只能贴在方法上 (ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME) // 定义这个注解的生命周期：在运行时仍然有效，这样AOP才能读取到它
public @interface Log {

    /**
     * 操作的描述信息，比如 "创建课程", "删除用户"
     * @return 描述文本
     */
    String description() default ""; // 定义一个名为description的属性，可以让我们在使用注解时传入描述

}
