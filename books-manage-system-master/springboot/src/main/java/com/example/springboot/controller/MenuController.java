package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Menu;
import com.example.springboot.mapper.MenuMapper;
import com.example.springboot.service.MenuService;
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
@RequestMapping("/menu")
public class MenuController {
    @Autowired
    private MenuMapper menuMapper;
    @Autowired
    private MenuService menuService;

    @GetMapping("/selectAll")
    public List<Menu> selectAll() {
        return menuMapper.selectAll();
    }

    @GetMapping("/selectById/{m_id}")
    public List<Menu> selectById(@PathVariable Integer m_id) {
        return menuMapper.selectById(m_id);
    }

    @GetMapping("/selectByIdStatus/{m_id}")
    public List<Menu> selectByIdStatus(@PathVariable Integer m_id) {
        return menuMapper.selectByIdStatus(m_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Menu menu) {
        return menuService.insertById(menu);
    }

    @DeleteMapping("/deleteById/{m_id}")
    public Integer deleteById(@PathVariable Integer m_id) {
        return menuMapper.deleteById(m_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Menu menu) {
        return menuService.updateById(menu);
    }


    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("路由表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Menu> menus = menuMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Menu.class).sheet("路由表").doWrite(menus);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Menu> lst = EasyExcel.read(inputStream) //调用read方法
                    .head(Menu.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            for (Menu menu : lst) {
                menuMapper.insertById(menu);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

}
