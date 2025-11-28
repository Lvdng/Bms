package com.example.springboot.controller;

import com.alibaba.excel.EasyExcel;
import com.example.springboot.entity.Borrow;
import com.example.springboot.entity.Sorts;
import com.example.springboot.mapper.SortsMapper;
import com.example.springboot.service.SortsService;
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
@RequestMapping("/sorts")
public class SortsController {

    @Autowired
    private SortsMapper sortsMapper;
    @Autowired
    private SortsService sortsService;

    @GetMapping("/selectAll")
    public List<Sorts> selectAll() {
        return sortsMapper.selectAll();
    }

    @GetMapping("/selectById/{s_id}")
    public List<Sorts> selectById(@PathVariable Integer s_id) {
        return sortsMapper.selectById(s_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody Sorts sorts) {
        return sortsService.insertById(sorts);
    }

    @DeleteMapping("/deleteById/{s_id}")
    public Integer deleteById(@PathVariable Integer s_id) {
        return sortsMapper.deleteById(s_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody Sorts sorts) {
        return sortsService.updateById(sorts);
    }


    /**
     * 导出数据
     */
    @GetMapping("exportExcel")
    public void exportData(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("图书类别表", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        List<Sorts> sorts = sortsMapper.selectAll();
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), Sorts.class).sheet("图书类别表").doWrite(sorts);
    }

    /**
     * 导入数据
     */
    @PostMapping("/importExcel")
    public Integer importData(MultipartFile file) {
        try {
            //获取文件的输入流
            InputStream inputStream = file.getInputStream();
            List<Sorts> lst = EasyExcel.read(inputStream) //调用read方法
                    .head(Sorts.class) //对应导入的实体类
                    .sheet(0) //导入数据的sheet页编号，0代表第一个sheet页，如果不填，则会导入所有sheet页的数据
                    .headRowNumber(1) //列表头行数，1代表列表头有1行，第二行开始为数据行
                    .doReadSync(); //开始读Excel，返回一个List<T>集合，继续后续入库操作
            for (Sorts sorts : lst) {
                sortsMapper.insertById(sorts);
            }
            return 1;
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
    }

}
