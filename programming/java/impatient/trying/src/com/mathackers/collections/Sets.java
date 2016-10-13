package com.mathackers.collections;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by andersc on 10/5/16.
 */
public class Sets {
    public static void main(String[] args) {
        // hash sets
        HashSet<String> badWords = new HashSet<>();
        badWords.add("sex");
        badWords.add("drugs");
        badWords.add("c++");

        System.out.println(badWords.contains("fuck"));

        // TreeSet
    }
}
