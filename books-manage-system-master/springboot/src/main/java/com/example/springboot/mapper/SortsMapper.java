package com.example.springboot.mapper;
import com.example.springboot.entity.Books;
import com.example.springboot.entity.Sorts;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SortsMapper {

    List<Sorts> selectAll();

    List<Sorts> selectById(Integer s_id);

    Integer deleteById(Integer s_id);

    Integer insertById(Sorts sorts);

    Integer updateById(Sorts sorts);
}
