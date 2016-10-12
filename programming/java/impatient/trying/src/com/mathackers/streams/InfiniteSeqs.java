package com.mathackers.streams;

import java.math.BigInteger;
import java.util.stream.Stream;

/**
 * Created by andersc on 10/6/16.
 */
public class InfiniteSeqs {
    public static void main(String[] args) {
        Stream<BigInteger> evens = Stream.iterate(BigInteger.ZERO, n -> n.add(BigInteger.valueOf(2)));
        Stream<BigInteger> first100 = evens.limit(100);
        for (Object i: first100.toArray())
            System.out.println(i);
    }
}
