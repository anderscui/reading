package com.mathackers.oop;

import java.time.DayOfWeek;
import java.time.LocalDate;

/**
 * Created by andersc on 9/27/16.
 */
public class Dates {

    public static void main(String[] args) {
        int year = 2016;
        int month = 9;

        LocalDate date = LocalDate.of(year, month, 1);
        DayOfWeek weekDay = date.getDayOfWeek();
        int value = weekDay.getValue();
        for (int i = 0; i < value; i++) {
            System.out.print("    ");
        }

        while (date.getMonthValue() == month) {
            System.out.printf("%4d", date.getDayOfMonth());
            if (date.getDayOfWeek().getValue() == 6) {
                System.out.println();
            }
            date = date.plusDays(1);
        }
    }
}
