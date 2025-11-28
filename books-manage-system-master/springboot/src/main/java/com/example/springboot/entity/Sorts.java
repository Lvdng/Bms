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
public class Sorts {
    @ColumnWidth(10)
    @ExcelProperty("类别编号")
    private int s_id;
    @ColumnWidth(10)
    @ExcelProperty("类别名称")
    private String s_sort;
    @ColumnWidth(20)
    @ExcelProperty("类别图标")
    private String s_icon;
    @ColumnWidth(10)
    @ExcelProperty("类别代码")
    private String s_code;
    @ColumnWidth(20)
    @ExcelProperty("类别状态")
    private int s_status;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("创建日期")
    private Date s_create;
}
