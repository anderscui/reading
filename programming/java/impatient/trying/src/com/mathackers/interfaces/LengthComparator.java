package com.mathackers.interfaces;

import java.util.Arrays;
import java.util.Comparator;

/**
 * Created by andersc on 10/1/16.
 */
public class LengthComparator implements Comparator<String> {
    @Override
    public int compare(String first, String second) {
        return first.length() - second.length();
    }

    public static void main(String[] args) {
        String[] friends = { "Peter", "Paul", "Mary" };
        Arrays.sort(friends, new LengthComparator());
        for (String friend : friends) {
            System.out.println(friend);
        }
    }
}
