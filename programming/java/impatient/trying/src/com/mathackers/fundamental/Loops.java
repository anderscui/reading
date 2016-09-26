package com.mathackers.fundamental;

import java.util.Arrays;

/**
 * Created by andersc on 9/25/16.
 */
public class Loops {
    public static void main(String[] args) {
        int[] numbers = { 1, 2, 3, 4, 5 };
        for (int i : numbers) {
            System.out.println(i);
        }

        System.out.println(Arrays.toString(numbers));
    }
}
