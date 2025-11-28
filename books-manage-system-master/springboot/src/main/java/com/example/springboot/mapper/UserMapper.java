package com.example.springboot.mapper;

import com.example.springboot.entity.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {

    List<User> selectAll();

    List<User> selectById(String u_id);

    Integer deleteById(String u_id);

    Integer insertById(User user);

    Integer updateById(User user);

    List<User> selectByIdPwd(String u_id, String u_pwd);

}
