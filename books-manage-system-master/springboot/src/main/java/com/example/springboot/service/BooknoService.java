package com.example.springboot.service;

import com.example.springboot.entity.Bookno;
import com.example.springboot.entity.Books;
import com.example.springboot.entity.Sorts;
import com.example.springboot.mapper.BooknoMapper;
import com.example.springboot.mapper.BooksMapper;
import com.example.springboot.mapper.SortsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class BooknoService {
    @Autowired
    private BooknoMapper booknoMapper;

    @Autowired
    private BooksMapper booksMapper;

    @Autowired
    private SortsMapper sortsMapper;

    public Integer insertById(Bookno bookno) {
        List<Books> books1 = booksMapper.selectById(bookno.getBs_id());
        if (books1 == null || books1.size() == 0) {
            return 0;
        }
        //
        if (bookno.getB_code() == null || Objects.equals(bookno.getB_code(), "")) {
            List<Sorts> sorts = sortsMapper.selectById(books1.get(0).getS_id());
            String s_code = sorts.get(0).getS_code();
            //
            List<Bookno> booknos = booknoMapper.selectByBsid(bookno.getBs_id());
            int size = booknos.size();
            bookno.setB_code(s_code + "-" + bookno.getBs_id() + "-" + size);
            bookno.setB_name(books1.get(0).getBs_name());
            Integer integer = booknoMapper.insertById(bookno);
            if (integer == 1) {
                Books books = books1.get(0);
                int bs_volume = books.getBs_volume() + 1;
                int bs_inventory = books.getBs_inventory() + 1;
                books.setBs_volume(bs_volume);
                books.setBs_inventory(bs_inventory);
                Integer integer1 = booksMapper.updateById(books);
                if (integer1 == 1) {
                    return 1;
                }
            }

        }
        //
        if (bookno.getB_code() != null || !Objects.equals(bookno.getB_code(), "")) {
            //
            List<Bookno> booknos = booknoMapper.selectById(bookno.getB_code());
            if (booknos == null || booknos.size() == 0) {
                //
                Integer integer = booknoMapper.insertById(bookno);
                if (integer == 1) {
                    Books books = books1.get(0);
                    int bs_volume = books.getBs_volume() + 1;
                    int bs_inventory = books.getBs_inventory() + 1;
                    books.setBs_volume(bs_volume);
                    books.setBs_inventory(bs_inventory);
                    Integer integer1 = booksMapper.updateById(books);
                    if (integer1 == 1) {
                        return 1;
                    }
                }
            }
        }
        return 0;
    }

    public Integer updateById(Bookno bookno) {
        List<Bookno> booknoList = booknoMapper.selectById(bookno.getB_code());
        if (booknoList == null || booknoList.size() == 0) {
            return 0;
        }
        return booknoMapper.updateById(bookno);
    }

    public Integer deleteById(String b_code) {
        List<Bookno> bookno = booknoMapper.selectById(b_code);
        if (bookno == null || bookno.size() == 0) {
            return 0;
        }
        String bs_id = bookno.get(0).getBs_id();
        //
        List<Books> books = booksMapper.selectById(bs_id);
        int bs_volume = books.get(0).getBs_volume();
        bs_volume = bs_volume - 1;
        int bs_inventory = books.get(0).getBs_inventory();
        bs_inventory = bs_inventory - 1;
        Integer integer = booknoMapper.deleteById(b_code);
        if (integer == 1) {
            Integer integer1 = booksMapper.updateByBsvolume(bs_id, bs_volume, bs_inventory);
            if (integer1 == 1) {
                return 1;
            }
        }
        return 0;
    }
}
