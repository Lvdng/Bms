package com.example.springboot.mapper;

import com.example.springboot.entity.Bookno;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BooknoMapper {

    List<Bookno> selectAll();

    List<Bookno> selectById(String b_code);

    Integer deleteById(String b_code);

    Integer insertById(Bookno bookno);

    Integer updateById(Bookno bookno);

    Integer deleteAllByBsid(String bs_id);

    List<Bookno> selectByIdStatus(String u_id, String bs_id);

    List<Bookno> selectByBsid(String bs_id);

    List<Bookno> selectByUid(String u_id);

    List<Bookno> selectByBname(String b_name);
}
