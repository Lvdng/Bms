package com.example.springboot.service;

import com.example.springboot.entity.Sorts;
import com.example.springboot.entity.User;
import com.example.springboot.entity.UserRole;
import com.example.springboot.mapper.SortsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SortsService {

    @Autowired
    private SortsMapper sortsMapper;

    public Integer insertById(Sorts sorts) {
        List<Sorts> sorts_temp = sortsMapper.selectById(sorts.getS_id());
        if (sorts_temp == null || sorts_temp.size() == 0) {
            sortsMapper.insertById(sorts);
            return 1;
        }
        return 0;

    }

    public Integer updateById(Sorts sorts) {
        List<Sorts> sorts_temp = sortsMapper.selectById(sorts.getS_id());
        if (sorts_temp == null || sorts_temp.size() == 0) {
            return 0;
        }
        return sortsMapper.updateById(sorts);
    }
}
