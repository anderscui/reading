package com.mathackers.fundamental;

/**
 * Created by andersc on 9/25/16.
 */
public class FormatedString {
    public static void main(String[] args) {
        System.out.printf("%8.2f \n", 1000.0/3);
        System.out.printf("%,+.2f \n", 100000.0/3);
        System.out.printf("Hello, %s. Next year, you'll be %d. \n", "Steve", 30);
    }
}
