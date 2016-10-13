package com.mathackers.fundamental;

/**
 * Created by andersc on 9/25/16.
 */
public class Variables {

    // global constant
    private static final int MONTHS_PER_YEAR = 12;

    public static void main(String[] args) {
        String 变量名 = "变量名";
        System.out.println(变量名);

        // local constant
        final int DAYS_PER_WEEK = 7;
        System.out.println(DAYS_PER_WEEK);
        System.out.println(MONTHS_PER_YEAR);
    }
}
