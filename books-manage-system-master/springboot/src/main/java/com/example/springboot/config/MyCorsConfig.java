package com.example.springboot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

//@Configuration(proxyBeanMethods = false)
//public class MyCorsConfig {
//    @Bean
//    public WebMvcConfigurer corsConfigurer() {
//        return new WebMvcConfigurer() {
//            @Override
//            public void addCorsMappings(CorsRegistry registry) {
//
//                registry.addMapping("/**");
//            }
//        };
//    }
//}
// 全局CORS配置类
@Configuration
public class MyCorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // 允许所有接口
                .allowedOrigins("http://localhost:5173") // 允许前端域名（开发环境可固定写死）
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // 允许的请求方法（必须包含DELETE和OPTIONS）
                .allowedHeaders("*") // 允许的请求头
                .allowCredentials(true) // 允许携带Cookie（如果需要）
                .maxAge(3600); // 预检请求缓存时间（减少重复预检）
    }
}