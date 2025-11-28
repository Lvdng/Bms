package com.example.springboot.mapper;


import com.example.springboot.entity.Menu;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MenuMapper {


    List<Menu> selectAll();

    Integer insertById(Menu menu);

    List<Menu> selectById(Integer m_id);

    Integer deleteById(Integer m_id);

    Integer updateById(Menu menu);
    List<Menu> selectByIdStatus(Integer m_id);
}
