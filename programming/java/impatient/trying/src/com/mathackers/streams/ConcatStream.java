package com.mathackers.streams;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

/**
 * Created by andersc on 10/6/16.
 */
public class ConcatStream {

    private static Stream<String> letters(String s) {
        List<String> result = new ArrayList<>();
        for (int i = 0; i < s.length(); i++) {
            result.add(s.substring(i, i+1));
        }
        return result.stream();
    }

    public static void main(String[] args) {
        Stream<Double> randoms = Stream.generate(Math::random);
        Stream<Double> page2 = randoms.skip(10).limit(10);
        for (Object d: page2.toArray())
            System.out.println(d);

        Stream<String> combined = Stream.concat(
                letters("Hello"), letters("World"));
        combined.forEach(System.out::println);
    }
}
