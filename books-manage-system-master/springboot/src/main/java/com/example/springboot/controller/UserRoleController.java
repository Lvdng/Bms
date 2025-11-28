package com.example.springboot.controller;

import com.example.springboot.entity.User;
import com.example.springboot.entity.UserRole;
import com.example.springboot.mapper.UserRoleMapper;
import com.example.springboot.service.UserRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/userRole")
public class UserRoleController {

    @Autowired
    private UserRoleMapper userRoleMapper;
    @Autowired
    private UserRoleService userRoleService;

    @GetMapping("/selectAll")
    public List<UserRole> selectAll() {
        return userRoleMapper.selectAll();
    }

    @GetMapping("/selectById/{u_id}")
    public List<UserRole> selectById(@PathVariable String u_id) {
        return userRoleMapper.selectById(u_id);
    }

    @PostMapping("/insertById")
    public Integer insertById(@RequestBody UserRole userRole) {
        return userRoleService.insertById(userRole);
    }

    @DeleteMapping("/deleteById/{u_id}")
    public Integer deleteById(@PathVariable String u_id) {
        return userRoleMapper.deleteById(u_id);
    }

    @PostMapping("/updateById")
    public Integer updateById(@RequestBody UserRole userRole) {
        return userRoleService.updateById(userRole);
    }

}
