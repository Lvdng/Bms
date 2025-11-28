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
public class Books {
    @ExcelProperty("图书编号")
    private String bs_id;
    @ColumnWidth(20)
    @ExcelProperty("图书ISBN号")
    private String bs_isbn;
    @ColumnWidth(20)
    @ExcelProperty("名称")
    private String bs_name;
    @ExcelProperty("类别")
    private int s_id;
    @ExcelProperty("作者")
    private String bs_auth;
    @ColumnWidth(20)
    @ExcelProperty("出版社")
    private String bs_publish;
    @ExcelProperty("价格")
    private double bs_price;
    @ExcelProperty("总数")
    private int bs_volume;
    @ExcelProperty("库存")
    private int bs_inventory;
    @ExcelProperty("状态")
    private int bs_status;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("创建时间")
    private Date bs_create;
}
