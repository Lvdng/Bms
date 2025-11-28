package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.User;
import com.example.springboot.mapper.UserMapper;
import com.example.springboot.service.UserService;
import com.example.springboot.utils.VerifyCodeUtils;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserService userService;

    @GetMapping("/selectAll")
    public List<User> selectAll() {
        return userService.selectAll();
    }

    @GetMapping("/selectById/{u_id}")
    public List<User> selectById(@PathVariable String u_id) {
        return userService.selectById(u_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody User user) {
        return userService.insertById(user);
    }

    @PostMapping("/insertByIdIde")
    public Integer insertByIdIde(@RequestBody User user) {
        return userService.insertByIdIde(user);
    }

    @DeleteMapping("/deleteById/{u_id}")
    public Integer deleteById(@PathVariable String u_id) {
        return userService.deleteById(u_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody User user) {
        return userService.updateById(user);
    }

    @GetMapping("/selectByIdPwd")
    public Object selectByIdPwd(@RequestParam String u_id, @RequestParam String u_pwd, @RequestParam String code, HttpSession session) {
//        if (code.equals(session.getAttribute("code").toString())) {
        u_pwd = DigestUtils.md5DigestAsHex(u_pwd.getBytes(StandardCharsets.UTF_8));
        return userService.selectByIdPwd(u_id, u_pwd);
//        }
//        return null;
    }

    @GetMapping("/generateImageCode")
    public void generateImageCode(HttpSession session, HttpServletResponse response) throws IOException {
        //随机生成四位随机数
        String code = VerifyCodeUtils.generateVerifyCode(4);
        //保存到session域中
        session.setAttribute("code", code);
        //根据随机数生成图片，reqponse响应图片
        response.setContentType("image/png");
        ServletOutputStream os = response.getOutputStream();
        VerifyCodeUtils.outputImage(130, 60, os, code);
    }

    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("用户表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<User> users = userMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), User.class).sheet("用户表").doWrite(users);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<User> lst = EasyExcel.read(inputStream) //调用read方法
                    //注册自定义监听器，字段校验可以在监听器内实现
                    //.registerReadListener(new UserListener())
                    .head(User.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            //模拟导入数据库操作
            for (User user : lst) {
//                Date date = user.getU_birth();
//                String form = String.format("%tF", date);
//                System.out.println(form);
                userService.insertByIdIde(user);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }
}
