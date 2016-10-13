package com.mathackers.fundamental;

import java.math.BigInteger;

/**
 * Created by andersc on 9/25/16.
 */
public class BigNumbers {
    public static void main(String[] args) {
        BigInteger n = BigInteger.valueOf(876543210123456789L);
        System.out.println(n);

        BigInteger r = BigInteger.valueOf(5).multiply(n.add(n));
        System.out.println(r);
    }

}
