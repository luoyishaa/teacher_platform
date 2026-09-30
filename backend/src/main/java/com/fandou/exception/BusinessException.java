package com.fandou.exception;

/**
 * 业务异常。
 *
 * 业务规则不满足时抛出这个异常，由 GlobalExceptionHandler 统一转成 ApiResponse，
 * 这样控制器里就不需要为每种错误各写一段 try/catch。
 */
public class BusinessException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    /** 业务状态码，默认 400 表示请求本身有问题 */
    private final int code;

    public BusinessException(String message) {
        this(400, message);
    }

    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
