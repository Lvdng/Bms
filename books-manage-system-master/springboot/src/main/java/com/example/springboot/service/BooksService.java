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

@Service
public class BooksService {

    @Autowired
    private BooksMapper booksMapper;

    @Autowired
    private BooknoMapper booknoMapper;

    @Autowired
    private SortsMapper sortsMapper;

    public Integer insertById(Books books) {
        List<Books> booksList = booksMapper.selectById(books.getBs_id());
        if (booksList == null || booksList.size() == 0) {
            booksMapper.insertById(books);
            int volume = books.getBs_volume();
            for (int i = 0; i < volume; i++) {
                List<Sorts> sorts = sortsMapper.selectById(books.getS_id());
                String s_code = sorts.get(0).getS_code();
                Bookno bookno = new Bookno();
                bookno.setB_code(s_code + '-' + books.getBs_id() + '-' + i);
                bookno.setBs_id(books.getBs_id());
                bookno.setB_status(1);
                bookno.setB_borrow(1);
                bookno.setB_name(books.getBs_name());
                booknoMapper.insertById(bookno);
            }
            return 1;
        }
        return 0;
    }

    public Integer updateById(Books books) {
        List<Books> booksList = booksMapper.selectById(books.getBs_id());
        if (booksList == null || booksList.size() == 0) {
            return 0;
        }
        //
        List<Bookno> bookno = booknoMapper.selectByBsid(books.getBs_id());
        for (Bookno value : bookno) {
            int b_borrow = value.getB_borrow();
            if (b_borrow == 0) {
                return 0;
            }
        }
        //
        Integer integer = deleteById(books.getBs_id());
        if (integer == 1) {
            Integer i = insertById(books);
            if (i == 1) {
                return 1;
            }
        }
        return 0;
    }

    public Integer deleteById(String bs_id) {
        List<Bookno> booknos = booknoMapper.selectByBsid(bs_id);
        for (int i = 0; i < booknos.size(); i++) {
            int b_borrow = booknos.get(i).getB_borrow();
            if (b_borrow == 0) {
                return 0;
            }
        }
        booknoMapper.deleteAllByBsid(bs_id);
        Integer is = booksMapper.deleteById(bs_id);
        if (is == 1) {
            return 1;
        }
        return 0;
    }

}
