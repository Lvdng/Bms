package com.example.springboot.entity;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.format.DateTimeFormat;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;


@Data
public class Bookno {
    @ExcelProperty("书本编号")
    private String b_code;
    @ExcelProperty("图书编号")
    private String bs_id;
    @ExcelProperty("借阅用户")
    private String u_id;
    @ColumnWidth(30)
    @ExcelProperty("图书名称")
    private String b_name;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("借阅日期")
    private Date b_borrow_date;
    @ExcelProperty("借阅状态")
    private int b_borrow;
    @ExcelProperty("书本状态")
    private int b_status;
}
