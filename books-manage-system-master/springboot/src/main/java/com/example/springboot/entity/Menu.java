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
public class Menu {
    @ColumnWidth(10)
    @ExcelProperty("路由编号")
    private int m_id;
    @ColumnWidth(20)
    @ExcelProperty("路由图标")
    private String m_icon;
    @ColumnWidth(15)
    @ExcelProperty("路由名称")
    private String m_name;
    @ColumnWidth(20)
    @ExcelProperty("路由路径")
    private String m_path;
    @ColumnWidth(20)
    @ExcelProperty("路由组件")
    private String m_component;
    @ColumnWidth(10)
    @ExcelProperty("路由状态")
    private Integer m_status;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("创建时间")
    private Date m_create;
}
