package com.mathackers.fundamental;

import java.util.Random;

public class HelloWorld {

    public static void main(String[] args) {
        System.out.println("Hello, World!");
        System.out.println("Hello, World!".length());

        Random random = new Random();
        System.out.println(random.nextInt());
        System.out.println(random.nextInt());
    }
}
