package com.example.springboot.service;

import com.example.springboot.entity.*;
import com.example.springboot.mapper.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UserRoleMapper userRoleMapper;
    @Autowired
    private RoleMapper roleMapper;
    @Autowired
    private RoleMenuMapper roleMenuMapper;
    @Autowired
    private MenuMapper menuMapper;


    public Integer insertById(User user) {
        String s = DigestUtils.md5DigestAsHex(user.getU_pwd().getBytes(StandardCharsets.UTF_8));
        user.setU_pwd(s);
        return userMapper.insertById(user);
    }

    public Integer insertByIdIde(User user) {
        List<User> user_temp = userMapper.selectById(user.getU_id());
        if (user_temp == null || user_temp.size() == 0) {
            Integer integer = insertById(user);
            if (integer == 1) {
                UserRole userRole = new UserRole();
                userRole.setU_id(user.getU_id());
                userRole.setR_id(4);
                Integer integer1 = userRoleMapper.insertById(userRole);
                if (integer1 == 1) {
                    return 1;
                }
            }
        }
        return 0;
    }

    public Integer updateById(User user) {
        List<User> user_temp = userMapper.selectById(user.getU_id());
        if (user_temp == null || user_temp.size() == 0) {
            return 0;
        }
        String s = DigestUtils.md5DigestAsHex(user.getU_pwd().getBytes(StandardCharsets.UTF_8));
        user.setU_pwd(s);
        return userMapper.updateById(user);
    }

    public User selectByIdPwd(String u_id, String u_pwd) {
        //验证用户是否存在
        List<User> user_temp = userMapper.selectById(u_id);
        if (user_temp == null || user_temp.size() == 0) {
            return null;
        }
        List<User> users = userMapper.selectByIdPwd(u_id, u_pwd);
        //验证密码是否正确
        if (users == null || users.size() == 0) {
            return null;
        }
        //获取用户规则列表
        List<UserRole> userRoles = userRoleMapper.selectById(u_id);
        users.get(0).setUserRoleList(userRoles);
        //获取用户规则详细
        List<Role> roles = roleMapper.selectById(userRoles.get(0).getR_id());
        if (roles == null) {
            users.get(0).setRoleList(null);
        }
        users.get(0).setRoleList(roles);
        //获取菜单列表
        List<RoleMenu> roleMenus = roleMenuMapper.selectById(userRoles.get(0).getR_id());
        users.get(0).setRoleMenuList(roleMenus);
        //获取菜单详细列表
        List<Menu> menuList = new ArrayList<>();
        for (RoleMenu roleMenu : roleMenus) {
            List<Menu> menus = menuMapper.selectByIdStatus(roleMenu.getM_id());
            if (menus.size() != 0) menuList.add(menus.get(0));
        }
        users.get(0).setMenuList(menuList);
        return users.get(0);
    }

    public List<User> selectById(String u_id) {
        //查找用户基本信息
        List<User> users = userMapper.selectById(u_id);
        //1--查找用户角色
        List<UserRole> userRoles = userRoleMapper.selectById(u_id);
        //添加用户角色
        users.get(0).setUserRoleList(userRoles);
        //2--查找角色列表
        List<Role> roles = roleMapper.selectById(userRoles.get(0).getR_id());
        //添加角色列表
        users.get(0).setRoleList(roles);
        //3--查找角色菜单
        List<RoleMenu> roleMenus = roleMenuMapper.selectById(userRoles.get(0).getR_id());
        //添加角色菜单
        users.get(0).setRoleMenuList(roleMenus);
        //4--获取菜单详细列表
        List<Menu> menuList = new ArrayList<>();
        for (RoleMenu roleMenu : roleMenus) {
            List<Menu> menus = menuMapper.selectByIdStatus(roleMenu.getM_id());
            if (menus.size() != 0) menuList.add(menus.get(0));
        }
        users.get(0).setMenuList(menuList);
        return users;
    }

    public List<User> selectAll() {
        List<User> users = userMapper.selectAll();
        for (User user : users) {
            List<UserRole> userRoles = userRoleMapper.selectById(user.getU_id());
            user.setUserRoleList(userRoles);
            List<Role> roles = roleMapper.selectById(userRoles.get(0).getR_id());
            user.setRoleList(roles);
            List<RoleMenu> roleMenus = roleMenuMapper.selectById(roles.get(0).getR_id());
            user.setRoleMenuList(roleMenus);
            List<Menu> menus = new ArrayList<>();
            for (RoleMenu roleMenu : roleMenus) {
                List<Menu> menu = menuMapper.selectByIdStatus(roleMenu.getM_id());
                if (menu.size() != 0) {
                    menus.add(menu.get(0));
                }
            }
            user.setMenuList(menus);
        }
        return users;
    }

    public Integer deleteById(String u_id) {
        userRoleMapper.deleteById(u_id);
        userMapper.deleteById(u_id);
        return 1;
    }
}
