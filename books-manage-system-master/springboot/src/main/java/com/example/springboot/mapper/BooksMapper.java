package com.example.springboot.mapper;

import com.example.springboot.entity.Books;
import com.example.springboot.entity.Menu;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BooksMapper {

    List<Books> selectAll();

    List<Books> selectById(String bs_id);

    Integer deleteById(String bs_id);

    Integer insertById(Books books);

    Integer updateById(Books books);

    Integer updateByBorrow(String bs_id, int bs_inventory);

    Integer updateByBsvolume(String bs_id, int bs_volume, int bs_inventory);
}
