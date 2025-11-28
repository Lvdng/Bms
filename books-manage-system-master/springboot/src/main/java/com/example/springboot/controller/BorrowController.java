package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Borrow;
import com.example.springboot.entity.BorrowEcharts;
import com.example.springboot.mapper.BorrowMapper;
import com.example.springboot.service.BorrowService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/borrow")
public class BorrowController {

    @Autowired
    private BorrowMapper borrowMapper;
    @Autowired
    private BorrowService borrowService;

    @GetMapping("/selectAll")
    public List<Borrow> selectAll() {
        return borrowMapper.selectAll();
    }

    @GetMapping("/selectById/{br_serial}")
    public List<Borrow> selectById(@PathVariable Integer br_serial) {
        return borrowMapper.selectById(br_serial);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Borrow borrow) {
        return borrowService.insertById(borrow);
    }

    @DeleteMapping("/deleteById/{br_serial}")
    public Integer deleteById(@PathVariable Integer br_serial) {
        return borrowMapper.deleteById(br_serial);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Borrow borrow) {
        return borrowService.updateById(borrow);
    }

    @PostMapping("/insertByBorrow")
    public Integer insertByBorrow(@RequestBody Borrow borrow) {
        return borrowService.insertByBorrow(borrow);
    }

    @PostMapping("/borrowBook")
    public Integer borrowBook(@RequestParam String u_id, @RequestParam String b_code, @RequestParam int br_borrow) {
        return borrowService.borrowBook(u_id, b_code, br_borrow);
    }

    @GetMapping("/selectByUid")
    public List<Borrow> selectByUid(@RequestParam String u_id) {
        return borrowMapper.selectByUid(u_id);
    }

    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("借阅流水表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Borrow> borrows = borrowMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Borrow.class).sheet("借阅流水表").doWrite(borrows);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Borrow> lst = EasyExcel.read(inputStream) //调用read方法
                    .head(Borrow.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            for (Borrow borrow : lst) {
                borrowService.insertById(borrow);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

    /**
     * echarts查询
     */
    @GetMapping("/selectByEcharts")
    public ArrayList<BorrowEcharts> selectByEcharts(@RequestParam String start, @RequestParam String end) {
        return borrowService.selectByEcharts(start, end);
    }


}
