package com.fandou.aop;

import com.fandou.entity.OperationLog;
import com.fandou.service.LogService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

@Aspect
@Component
public class LogAspect {

    @Autowired
    private LogService logservice;

    //定义切点，匹配所有带@log注解的方法
    @Pointcut("@annotation(com.fandou.aop.Log)")
    public void logPointCut(){}

    // 定义后置通知，在方法成功执行后触发,也就是说所有带log注释的方法都完成之后，才记录下来
    @AfterReturning(pointcut = "logPointCut()")
    public void doAfterReturning(JoinPoint joinPoint){
        handleLog(joinPoint);
    }

    private void handleLog(final JoinPoint joinPoint) {
        System.out.println("====== AOP日志切面被触发了！ ======");
        try{
            Log controllerLog = getAnnotationLog(joinPoint);
            if(controllerLog==null){
                return;
            }

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//            if(authentication==null||!authentication.isAuthenticated()||"anonymousUser".equals(authentication.getPrincipal())){
//                return;
//                //如果未登录则不记录
//            }
            String username=authentication.getName();

            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            String ip=request.getRemoteAddr();

            OperationLog operLog=new OperationLog();
            operLog.setUsername(username);
            operLog.setIp(ip);
            operLog.setCreateTime(new Date());
            operLog.setDescription(controllerLog.description());

            String className=joinPoint.getTarget().getClass().getName();
            String methodName=joinPoint.getSignature().getName();
            operLog.setMethod(className+"."+methodName+"()");

            logservice.saveLog(operLog);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    private Log getAnnotationLog(JoinPoint joinPoint){
        try{
            MethodSignature signature=(MethodSignature)joinPoint.getSignature();
            return signature.getMethod().getAnnotation(Log.class);
        }catch(Exception e){
            return null;
        }
    }
}
