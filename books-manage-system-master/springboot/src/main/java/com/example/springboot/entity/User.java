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
public class User {
    @ExcelProperty("账号")
    private String u_id;
    @ColumnWidth(40)
    @ExcelProperty("密码")
    private String u_pwd;
    @ExcelProperty("姓名")
    private String u_name;
    @ExcelProperty("性别")
    private String u_sex;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("出生日期")
    private Date u_birth;
    @ExcelProperty("状态")
    private int u_status;
    @ColumnWidth(20)
    @DateTimeFormat("yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @ExcelProperty("创建日期")
    private Date u_create;
    private List<UserRole> userRoleList;
    private List<Role> roleList;
    private List<RoleMenu> roleMenuList;
    private List<Menu> menuList;
}
