package com.example.springboot.service;

import com.example.springboot.entity.Menu;
import com.example.springboot.mapper.MenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuService {

    @Autowired
    private MenuMapper menuMapper;


    public Integer insertById(Menu menu) {
        List<Menu> menu_temp = menuMapper.selectById(menu.getM_id());
        if (menu_temp == null || menu_temp.size() == 0) {
            return menuMapper.insertById(menu);
        }
        return 0;
    }

    public Integer updateById(Menu menu) {
        List<Menu> menu_temp = menuMapper.selectById(menu.getM_id());
        if (menu_temp == null || menu_temp.size() == 0) {
            return 0;
        }
        return menuMapper.updateById(menu);
    }
}
