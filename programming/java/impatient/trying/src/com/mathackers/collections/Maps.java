package com.mathackers.collections;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by andersc on 10/5/16.
 */
public class Maps {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();
        map.put("Alice", 1);
        map.put("Bill", 2);
        System.out.println(map.get("Bill"));
        System.out.println(map.get("Carmark"));
        System.out.println(map.getOrDefault("Carmark", 1));

        // update -> merge
        map.merge("Bill", 1, Integer::sum);
        System.out.println(map.get("Bill")); // 3
    }
}
