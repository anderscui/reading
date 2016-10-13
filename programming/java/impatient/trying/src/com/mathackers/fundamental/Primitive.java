package com.mathackers.fundamental;

/**
 * Created by andersc on 9/25/16.
 */
public class Primitive {
    public static void main(String[] args) {
        // 8 primitive types
        // int, long, short, byte
        // float, double
        // char, bool

        System.out.println(0xFF);
        System.out.println(011);
        System.out.println(0b1001);

        System.out.println(1_000_000);

        System.out.println('\u263A');

        // lose info during conversion
        float f = 123456789;
        System.out.println(f);
    }
}
