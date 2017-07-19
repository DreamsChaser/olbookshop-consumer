package cn.com.njit.wd.consumer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;

/**
 * Created by wangdi on 2017/3/20.
 */
@SpringBootApplication
@ImportResource({"classpath:dubbo-consumer.xml"})
public class WarApplication {
    public static void main(String[] args) {
        SpringApplication.run(WarApplication.class);
    }
}
