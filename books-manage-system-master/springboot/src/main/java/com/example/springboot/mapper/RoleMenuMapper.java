package com.example.springboot.mapper;

import com.example.springboot.entity.RoleMenu;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface RoleMenuMapper {


    List<RoleMenu> selectAll();

    List<RoleMenu> selectById(Integer r_id);


    Integer deleteById(Integer r_id, Integer m_id);

    Integer updateById(RoleMenu roleMenu);

    List<RoleMenu> selectByIdMenu(Integer r_id, Integer m_id);

    Integer insertById(Integer r_id, Integer m_id);

    Integer deleteAll(Integer r_id);
}
