package com.example.springboot.mapper;
import com.example.springboot.entity.Bookno;
import com.example.springboot.entity.Borrow;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BorrowMapper {

    List<Borrow> selectAll();

    List<Borrow> selectById(Integer br_serial);

    Integer deleteById(Integer br_serial);

    Integer insertById(Borrow borrow);

    Integer updateById(Borrow borrow);
    Integer insertByBorrow(Borrow borrow);

    List<Borrow> selectByUid(String u_id);

    Integer selectByDebit(String format);

    Integer selectByReply(String format);
}
