package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Role;
import com.example.springboot.entity.Sorts;
import com.example.springboot.mapper.RoleMapper;
import com.example.springboot.service.RoleService;
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
@RequestMapping("/role")
public class RoleController {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private RoleService roleService;

    @GetMapping("/selectAll")
    public List<Role> selectAll() {
        return roleService.selectAll();
    }

    @GetMapping("/selectById/{r_id}")
    public List<Role> selectById(@PathVariable Integer r_id) {
        return roleService.selectById(r_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Role role) {
        return roleService.insertById(role);
    }

    @DeleteMapping("/deleteById/{r_id}")
    public Integer deleteById(@PathVariable Integer r_id) {
        return roleMapper.deleteById(r_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Role role) {
        return roleService.updateById(role);
    }

    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("角色表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Role> roles = roleMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Role.class).sheet("角色表").doWrite(roles);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Role> lst = EasyExcel.read(inputStream) //调用read方法
                    .head(Role.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            for (Role role : lst) {
                roleMapper.insertById(role);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }
}
