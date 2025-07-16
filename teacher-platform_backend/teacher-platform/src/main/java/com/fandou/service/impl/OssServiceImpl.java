package com.fandou.service.impl;

import com.aliyun.oss.OSS;
import com.fandou.service.OssService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.websocket.OnError;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@Service
public class OssServiceImpl implements OssService {

    @Autowired
    private OSS ossClient;
    @Value("${aliyun.oss.bucket-name}")
    private String bucketName;
    @Value("${aliyun.oss.endpoint}")
    private String endpoint;
    @Override
    public String uploadFile(MultipartFile file) throws Exception {
        //获取文件上传的输入流
        InputStream inputStream=file.getInputStream();
        //生产唯一的文件名，防止覆盖，使用日期/UUID-原始文件名的格式
        String originalFilename=file.getOriginalFilename();
        String uuid= UUID.randomUUID().toString().replaceAll("-","");
        String datePath=new SimpleDateFormat("yyyy/MM/dd").format(new Date());
        String objectName=datePath+"/"+uuid+"_"+originalFilename;
        try{
            //如何上传呢？调用OSS客户端的putObject方法进行上传
            //参数需要bucket名称，在OSS上的完整路径+文件名，文件输入流
            ossClient.putObject(bucketName,objectName,inputStream);
            //拼接好后的文件完整访问路径为：https://<bucketName>.<Endpoint>/<ObjectName>
            String fileUrl="http://"+bucketName+"."+endpoint+"/"+objectName;
            return fileUrl;
        }finally {
            //关闭输入流
            if(inputStream!=null) {
                inputStream.close();
            }
        }
    }
}
