package com.example.springboot.mapper;

import com.example.springboot.entity.UserRole;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserRoleMapper {

    List<UserRole> selectAll();

    List<UserRole> selectById(String u_id);

    Integer deleteById(String u_id);

    Integer insertById(UserRole userRole);

    Integer updateById(UserRole userRole);

    List<UserRole> selectByRid(Integer r_id);
}
