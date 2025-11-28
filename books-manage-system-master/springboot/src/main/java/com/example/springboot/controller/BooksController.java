package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Books;
import com.example.springboot.entity.User;
import com.example.springboot.mapper.BooksMapper;
import com.example.springboot.service.BooksService;
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
@RequestMapping("/books")
public class BooksController {

    @Autowired
    private BooksMapper booksMapper;
    @Autowired
    private BooksService booksService;

    @GetMapping("/selectAll")
    public List<Books> selectAll() {
        return booksMapper.selectAll();
    }

    @GetMapping("/selectById/{bs_id}")
    public List<Books> selectById(@PathVariable String bs_id) {
        return booksMapper.selectById(bs_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Books books) {
        return booksService.insertById(books);
    }

    @DeleteMapping("/deleteById/{bs_id}")
    public Integer deleteById(@PathVariable String bs_id) {
        return booksService.deleteById(bs_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Books books) {
        return booksService.updateById(books);
    }

    @PostMapping("/updateByBorrow")
    public Integer updateByBorrow(@RequestParam String bs_id, @RequestParam int bs_inventory) {
        return booksMapper.updateByBorrow(bs_id, bs_inventory);
    }

    @PostMapping("/updateByBsvolume")
    public Integer updateByBsvolume(@RequestParam String bs_id, @RequestParam int bs_volume, @RequestParam int bs_inventory) {
        return booksMapper.updateByBsvolume(bs_id, bs_volume, bs_inventory);
    }

    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("图书表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Books> books = booksMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Books.class).sheet("图书表").doWrite(books);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Books> lst = EasyExcel.read(inputStream) //调用read方法
                    .head(Books.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            for (Books books : lst) {
                booksService.insertById(books);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }


}
