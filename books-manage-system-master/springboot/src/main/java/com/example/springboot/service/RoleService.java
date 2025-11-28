package com.example.springboot.service;

import com.example.springboot.entity.Menu;
import com.example.springboot.entity.Role;
import com.example.springboot.entity.RoleMenu;
import com.example.springboot.mapper.MenuMapper;
import com.example.springboot.mapper.RoleMapper;
import com.example.springboot.mapper.RoleMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private RoleMenuMapper roleMenuMapper;

    @Autowired
    private MenuMapper menuMapper;

    public Integer insertById(Role role) {
        List<Role> role_temp = roleMapper.selectById(role.getR_id());
        if (role_temp == null || role_temp.size() == 0) {
            return roleMapper.insertById(role);
        }
        return 0;
    }

    public Integer updateById(Role role) {
        List<Role> role_temp = roleMapper.selectById(role.getR_id());
        if (role_temp == null || role_temp.size() == 0) {
            return 0;
        }
        return roleMapper.updateById(role);
    }

    public List<Role> selectAll() {
        List<Role> roles = roleMapper.selectAll();
        for (Role role : roles) {
            List<RoleMenu> roleMenus = roleMenuMapper.selectById(role.getR_id());
            role.setRoleMenuList(roleMenus);
            List<Menu> menus = new ArrayList<>();
            for (RoleMenu roleMenu : roleMenus) {
                List<Menu> menu = menuMapper.selectById(roleMenu.getM_id());
                if (menu.size() != 0) {
                    menus.add(menu.get(0));
                }
            }
            role.setMenuList(menus);
        }
        return roles;
    }

    public List<Role> selectById(Integer r_id) {
        List<Role> roles = roleMapper.selectById(r_id);
        List<RoleMenu> roleMenus = roleMenuMapper.selectById(r_id);
        roles.get(0).setRoleMenuList(roleMenus);
        List<Menu> menus = new ArrayList<>();
        for (RoleMenu roleMenu : roleMenus) {
            List<Menu> lst = menuMapper.selectById(roleMenu.getM_id());
            menus.add(lst.get(0));
        }
        roles.get(0).setMenuList(menus);
        return roles;
    }
}
