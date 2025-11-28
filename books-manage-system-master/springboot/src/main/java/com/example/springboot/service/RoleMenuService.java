package com.example.springboot.service;

import com.example.springboot.entity.RoleMenu;
import com.example.springboot.entity.UserRole;
import com.example.springboot.mapper.RoleMenuMapper;
import com.example.springboot.mapper.UserRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleMenuService {
    @Autowired
    private RoleMenuMapper roleMenuMapper;

    @Autowired
    private UserRoleMapper userRoleMapper;

    public Integer insertById(Integer r_id, Integer m_id) {
        List<RoleMenu> roleMenu_temp = roleMenuMapper.selectByIdMenu(r_id, m_id);
        if (roleMenu_temp == null || roleMenu_temp.size() == 0) {
            return roleMenuMapper.insertById(r_id, m_id);
        }
        return 0;
    }

    public Integer updateById(RoleMenu roleMenu) {
        List<RoleMenu> roleMenu_temp = roleMenuMapper.selectById(roleMenu.getR_id());
        if (roleMenu_temp == null || roleMenu_temp.size() == 0) {
            return 0;
        }
        return roleMenuMapper.updateById(roleMenu);
    }

    public Integer deleteAllWithUser(Integer r_id) {
        List<UserRole> userRoles = userRoleMapper.selectByRid(r_id);
        if (userRoles == null || userRoles.size() == 0) {
            return roleMenuMapper.deleteAll(r_id);
        }
        return 0;
    }
}
