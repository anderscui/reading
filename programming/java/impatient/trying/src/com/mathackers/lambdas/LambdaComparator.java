package com.mathackers.lambdas;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by andersc on 10/1/16.
 */
public class LambdaComparator {
    public static void main(String[] args) {
        String[] friends = { "Peter", "Paul", "Mary" };
        Arrays.sort(friends, (first, second) -> second.length() - first.length());

        System.out.println(Arrays.toString(friends));

        ArrayList<String> list = new ArrayList<>();
        list.add("one");
        list.add("two");
        list.add("three");
        list.forEach(System.out::println);
    }
}
