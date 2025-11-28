package com.example.springboot.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
public class BorrowEcharts {
    private int debit;
    private int reply;
    private String date;
}
