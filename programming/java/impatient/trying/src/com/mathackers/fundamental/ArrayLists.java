package com.mathackers.fundamental;

import java.util.ArrayList;

/**
 * Created by andersc on 9/25/16.
 */
public class ArrayLists {
    public static void main(String[] args) {
        ArrayList<String> names = new ArrayList<>();
        names.add("Steve");
        names.add("Pink");
        names.add("Gun");
        names.remove(1);
        for (int i = 0; i < names.size(); i++) {
            System.out.println(names.get(i));
        }
    }
}
