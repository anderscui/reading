package com.mathackers.oop;

import java.util.Arrays;

/**
 * Created by andersc on 10/4/16.
 */
//public enum Size {
//    SMALL,
//    MEDIUM,
//    LARGE,
//    EXTRA_LARGE
//};

public enum Size {
    SMALL("S"),
    MEDIUM("M"),
    LARGE("L"),
    EXTRA_LARGE("XL");

    private String abbr;

    Size(String abbr) {
        this.abbr = abbr;
    }

    public String getAbbr() {
        return abbr;
    }
};

class SizeClient {
    public static void main(String[] args) {
        Size small = Size.valueOf("SMALL");
        System.out.println(small);

        System.out.println(Arrays.toString(Size.values()));

        System.out.println(Size.MEDIUM.ordinal());
        System.out.println(Size.MEDIUM.getAbbr());
    }
}