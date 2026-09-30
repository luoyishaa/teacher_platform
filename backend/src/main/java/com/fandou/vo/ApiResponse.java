package com.fandou.vo;
import lombok.Data;

@Data // Lombok注解，自动为所有字段生成getter, setter, toString, equals, hashCode方法
public class ApiResponse<T> {

    private Integer code;

    private String message;

    private T data;

    private ApiResponse() {}

    private ApiResponse(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(200, "操作成功", data);
    }

    public static <T> ApiResponse<T> success() {
        return success(null);
    }

    public static <T> ApiResponse<T> success(String message) {
        // 在这种情况下，data通常为null
        return new ApiResponse<>(200, message, null);
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(200, message, data);
    }
    public static <T> ApiResponse<T> error(Integer code, String message) {
        return new ApiResponse<>(code, message, null);
    }
}