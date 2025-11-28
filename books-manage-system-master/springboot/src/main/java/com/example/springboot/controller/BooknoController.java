package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Bookno;
import com.example.springboot.entity.User;
import com.example.springboot.mapper.BooknoMapper;
import com.example.springboot.service.BooknoService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/bookno")
public class BooknoController {

    @Autowired
    private BooknoMapper booknoMapper;
    @Autowired
    private BooknoService booknoService;

    @GetMapping("/selectAll")
    public List<Bookno> selectAll() {
        return booknoMapper.selectAll();
    }

    @GetMapping("/selectById/{b_code}")
    public List<Bookno> selectById(@PathVariable String b_code) {
        return booknoMapper.selectById(b_code);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Bookno bookno) {
        return booknoService.insertById(bookno);
    }

    @DeleteMapping("/deleteById/{b_code}")
    public Integer deleteById(@PathVariable String b_code) {
        return booknoService.deleteById(b_code);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Bookno bookno) {
        return booknoService.updateById(bookno);
    }

    @DeleteMapping("/deleteAllByBsid/{bs_id}")
    public Integer deleteAllByBsid(@PathVariable String bs_id) {
        return booknoMapper.deleteAllByBsid(bs_id);
    }

    @GetMapping("/selectByIdStatus")
    public List<Bookno> selectByIdStatus(@RequestParam String u_id, @RequestParam String bs_id) {
        return booknoMapper.selectByIdStatus(u_id, bs_id);
    }

    @GetMapping("/selectByBsid")
    public List<Bookno> selectByBsid(@RequestParam String bs_id) {
        return booknoMapper.selectByBsid(bs_id);
    }

    @GetMapping("/selectByUid")
    public List<Bookno> selectByUid(@RequestParam String u_id) {
        return booknoMapper.selectByUid(u_id);
    }

    @GetMapping("/selectByBname")
    public List<Bookno> selectByBname(@RequestParam String b_name) {
        return booknoMapper.selectByBname(b_name);
    }

    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("书本表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Bookno> booknos = booknoMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Bookno.class).sheet("书本表").doWrite(booknos);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Bookno> lst = EasyExcel.read(inputStream) //调用read方法
                    //注册自定义监听器，字段校验可以在监听器内实现
                    //.registerReadListener(new UserListener())
                    .head(Bookno.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            //模拟导入数据库操作
            for (Bookno bookno : lst) {
                booknoService.insertById(bookno);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }


}
