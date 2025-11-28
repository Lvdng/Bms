package com.example.springboot.controller;

import com.example.springboot.entity.RoleMenu;
import com.example.springboot.mapper.RoleMenuMapper;
import com.example.springboot.service.RoleMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/roleMenu")
public class RoleMenuController {

    @Autowired
    private RoleMenuMapper roleMenuMapper;

    @Autowired
    private RoleMenuService roleMenuService;

    @GetMapping("/selectAll")
    public List<RoleMenu> selectAll() {
        return roleMenuMapper.selectAll();
    }

    @GetMapping("/selectById/{r_id}")
    public List<RoleMenu> selectById(@PathVariable Integer r_id) {
        return roleMenuMapper.selectById(r_id);
    }

    @GetMapping("/selectByIdMenu")
    public List<RoleMenu> selectByIdMenu(@RequestParam Integer r_id, @RequestParam Integer m_id) {
        return roleMenuMapper.selectByIdMenu(r_id, m_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestParam Integer r_id, @RequestParam Integer m_id) {
        return roleMenuService.insertById(r_id, m_id);
    }

    @DeleteMapping("/deleteById")
    public Integer deleteById(@RequestParam Integer r_id, @RequestParam Integer m_id) {
        return roleMenuMapper.deleteById(r_id, m_id);
    }

    @DeleteMapping("/deleteAll")
    public Integer deleteAll(@RequestParam Integer r_id) {
        return roleMenuMapper.deleteAll(r_id);
    }

    @DeleteMapping("/deleteAllWithUser")
    public Integer deleteAllWithUser(@RequestParam Integer r_id) {
        return roleMenuService.deleteAllWithUser(r_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody RoleMenu roleMenu) {
        return roleMenuService.updateById(roleMenu);
    }

}
