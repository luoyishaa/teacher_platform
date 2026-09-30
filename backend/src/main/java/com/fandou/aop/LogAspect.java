package com.fandou.aop;

import com.fandou.entity.OperationLog;
import com.fandou.service.LogService;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import java.util.Date;

@Aspect
@Component
public class LogAspect {
    private static final Logger logger = LoggerFactory.getLogger(LogAspect.class);
    private final LogService logs;
    public LogAspect(LogService logs) { this.logs = logs; }

    @AfterReturning("@annotation(com.fandou.aop.Log)")
    public void record(JoinPoint point) {
        try {
            Log annotation = ((MethodSignature) point.getSignature()).getMethod().getAnnotation(Log.class);
            if (annotation == null) return;
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            var request = RequestContextHolder.getRequestAttributes();
            HttpServletRequest servletRequest = request instanceof ServletRequestAttributes
                    ? ((ServletRequestAttributes) request).getRequest() : null;
            OperationLog entry = new OperationLog();
            entry.setUsername(auth == null ? "anonymous" : auth.getName());
            entry.setDescription(annotation.description());
            entry.setMethod(point.getSignature().toShortString());
            entry.setIp(servletRequest == null ? null : servletRequest.getRemoteAddr());
            entry.setCreateTime(new Date());
            logs.saveLog(entry);
        } catch (RuntimeException error) {
            logger.error("Failed to record operation", error);
        }
    }
}
