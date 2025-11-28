package com.example.springboot.mapper;

import com.example.springboot.entity.Role;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface RoleMapper {

    List<Role> selectAll();

    List<Role> selectById(Integer r_id);

    Integer insertById(Role role);

    Integer deleteById(Integer r_id);

    Integer updateById(Role role);
}
