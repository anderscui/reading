package com.mathackers.exceptions;

import java.util.Random;

/**
 * Created by andersc on 10/4/16.
 */
public class RandomGen {
    private static Random generator = new Random();


    /**
     * generates a random integer between the specified range.
     * @param low: lower bound of random interger.
     * @param high: upper bound.
     * @return an integer.
     */
    public static int randInt(int low, int high) {
        if (low > high)
            throw new IllegalArgumentException(
                    String.format("low should be <= high, but low is %d and high is %d",
                            low, high)
            );
        return low + (int)(generator.nextDouble() * (high - low + 1));
    }

    public static void main(String[] args) {
        System.out.println(randInt(5, 10));
        System.out.println(randInt(10, 5));
    }
}
