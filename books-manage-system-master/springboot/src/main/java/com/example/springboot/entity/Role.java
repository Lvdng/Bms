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
import java.util.List;

@Data
public class Role {
    @ColumnWidth(10)
    @ExcelProperty("角色编号")
    private int r_id;
    @ColumnWidth(20)
    @ExcelProperty("角色名称")
    private String r_ide;
    @ColumnWidth(20)
    @ExcelProperty("角色图标")
    private String r_icon;
    @ColumnWidth(10)
    @ExcelProperty("最大借书本数")
    private int r_limit_book;
    @ColumnWidth(10)
    @ExcelProperty("最大借书天数")
    private int r_limit_day;
    @ColumnWidth(10)
    @ExcelProperty("角色状态")
    private int r_status;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("创建时间")
    private Date r_create;
    private List<RoleMenu> roleMenuList;
    private List<Menu> menuList;
}
