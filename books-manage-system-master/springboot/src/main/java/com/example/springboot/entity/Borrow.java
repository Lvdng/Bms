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
public class Borrow {
    @ExcelProperty("用户账户")
    private String u_id;
    @ExcelProperty("书本编号")
    private String b_code;
    @ExcelProperty("借书/还书")
    private int br_borrow;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("借还日期")
    private Date br_debit_reply;
    @ExcelProperty("流水号")
    private int br_serial;
}
