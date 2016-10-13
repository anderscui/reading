package com.mathackers.collections;

import java.util.Iterator;
import java.util.Stack;

/**
 * Created by andersc on 10/5/16.
 */
public class Stacks {
    public static void main(String[] args) {
        Stack<Integer> nums = new Stack<>();
        nums.add(3);
        nums.add(2);
        nums.add(1);
        // for is for all Iterable<E>
        for (int n: nums) {
            System.out.println(n);
        }
        System.out.println(nums.peek());

        Iterator<Integer> iter = nums.iterator();
        while (iter.hasNext()) {
            int elem = iter.next();
            System.out.println(elem);
        }

        nums.removeIf(i -> i % 2 == 0);
        for (int n: nums) {
            System.out.println(n);
        }
    }
}
