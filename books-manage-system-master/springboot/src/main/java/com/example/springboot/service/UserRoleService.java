package com.example.springboot.service;

import com.example.springboot.entity.User;
import com.example.springboot.entity.UserRole;
import com.example.springboot.mapper.UserRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserRoleService {

    @Autowired
    private UserRoleMapper userRoleMapper;

    public Integer insertById(UserRole userRole) {
        List<UserRole> userRole_temp = userRoleMapper.selectById(userRole.getU_id());
        if (userRole_temp == null || userRole_temp.size() == 0) {
            return userRoleMapper.insertById(userRole);
        }
        return 0;
    }

    public Integer updateById(UserRole userRole) {
        List<UserRole> userRole_temp = userRoleMapper.selectById(userRole.getU_id());
        if (userRole_temp == null || userRole_temp.size() == 0) {
            return 0;
        }
        return userRoleMapper.updateById(userRole);
    }
}
