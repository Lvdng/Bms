package com.example.springboot.service;

import com.example.springboot.entity.*;
import com.example.springboot.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Objects;

@Service
public class BorrowService {

    @Autowired
    private BorrowMapper borrowMapper;

    @Autowired
    private BooknoMapper booknoMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BooksMapper booksMapper;

    @Autowired
    private SortsMapper sortsMapper;

    public Integer insertById(Borrow borrow) {
        return borrowMapper.insertById(borrow);
    }

    public Integer updateById(Borrow borrow) {
        return borrowMapper.updateById(borrow);
    }

    public Integer insertByBorrow(Borrow borrow) {
        return borrowMapper.insertByBorrow(borrow);
    }

    public Integer borrowBook(String u_id, String b_code, int br_borrow) {
        if (br_borrow != 0 && br_borrow != 1) {
            return 0;
        }
        List<User> users = userMapper.selectById(u_id);
        if (users == null || users.size() == 0) {
            return 0;
        }
        List<Bookno> booknos = booknoMapper.selectById(b_code);
        if (booknos == null || booknos.size() == 0) {
            return 0;
        }
        String bs_id = b_code.substring(2, 7);// L-00002-0
        List<Books> _books = booksMapper.selectById(bs_id);
        int br_inventory = _books.get(0).getBs_inventory();

        Bookno bookno = new Bookno();
        if (br_borrow == 0) {
            List<Sorts> sorts = sortsMapper.selectById(_books.get(0).getS_id());
            int s_status = sorts.get(0).getS_status();
            if (s_status == 0) {
                return 0;
            }
            if (_books.get(0).getBs_status() == 0) {
                return 0;
            }
            if (booknos.get(0).getB_status() == 0) {
                return 0;
            }
            if (booknos.get(0).getB_borrow() == 0) {
                return 0;
            }
            if (br_inventory == 0) {
                return 0;
            }
            //
            bookno.setU_id(u_id);
            bookno.setB_code(b_code);
            bookno.setB_borrow(br_borrow);
            bookno.setBs_id(bs_id);
            List<Books> books = booksMapper.selectById(bs_id);
            if (books == null || books.size() == 0) {
                return 0;
            }
            bookno.setB_name(books.get(0).getBs_name());
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
            Date date = new Date(System.currentTimeMillis());
            String nowDate = formatter.format(date).substring(0, 10);
            bookno.setB_borrow_date(Date.valueOf(nowDate));
            bookno.setB_status(1);
            Integer integer1 = booknoMapper.updateById(bookno);
            if (integer1 == 0) {
                return 0;
            }
            //
            br_inventory = br_inventory - 1;
            Integer integer = booksMapper.updateByBorrow(bs_id, br_inventory);
            if (integer == 1) {
                //
                Borrow borrow = new Borrow();
                borrow.setU_id(u_id);
                borrow.setB_code(b_code);
                borrow.setBr_borrow(br_borrow);
                Integer integer2 = borrowMapper.insertByBorrow(borrow);
                if (integer2 == 1) {
                    return 1;
                }
            }
        }

        if (br_borrow == 1) {
            if (booknos.get(0).getB_borrow() == 1) {
                return 0;
            }
            if (!Objects.equals(booknos.get(0).getU_id(), u_id)) {
                return 0;
            }
            //
            bookno.setB_code(b_code);
            bookno.setB_borrow(br_borrow);
            bookno.setBs_id(bs_id);
            List<Books> books = booksMapper.selectById(bs_id);
            if (books == null || books.size() == 0) {
                return 0;
            }
            bookno.setB_name(books.get(0).getBs_name());
            bookno.setU_id(null);
            bookno.setB_borrow_date(null);
            bookno.setB_status(1);
            Integer integer = booknoMapper.updateById(bookno);
            if (integer == 0) {
                return 0;
            }
            //
            br_inventory = br_inventory + 1;
            booksMapper.updateByBorrow(bs_id, br_inventory);

            Borrow borrow = new Borrow();
            borrow.setU_id(u_id);
            borrow.setB_code(b_code);
            borrow.setBr_borrow(br_borrow);
            Integer integer2 = borrowMapper.insertByBorrow(borrow);
            if (integer2 == 1) {
                return 1;
            }
        }
        return 0;
    }

    public ArrayList<BorrowEcharts> selectByEcharts(String start, String end) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  // 日期格式化
        try {
            java.util.Date startDate = sdf.parse(start);  // 起始日期
            java.util.Date endDate = sdf.parse(end);  // 结束日期
            java.util.Date temp = startDate;
            Calendar instance = Calendar.getInstance();
            instance.setTime(startDate);
            int index = 0;
            ArrayList<BorrowEcharts> borrowEchartsList = new ArrayList<>();
            while (temp.getTime() < endDate.getTime()) {
                temp = instance.getTime();
                String format = sdf.format(temp);
                //System.out.println(format);  // 打印中间的日期
                Integer debit = borrowMapper.selectByDebit(format);
                Integer reply = borrowMapper.selectByReply(format);
                instance.add(Calendar.DAY_OF_MONTH, 1);  // 天数加上1
                BorrowEcharts borrowEcharts = new BorrowEcharts();
                borrowEcharts.setDebit(debit);
                borrowEcharts.setReply(reply);
                borrowEcharts.setDate(format);
                borrowEchartsList.add(index, borrowEcharts);
                index = index + 1;
            }
            return borrowEchartsList;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }
}
