package com.mathackers.streams;

import java.util.Optional;
import java.util.stream.Stream;

/**
 * Created by andersc on 10/6/16.
 */
public class Reductions {
    public static void main(String[] args) {
        Stream<String> words = Stream.of("merrily", "merrily", "gently", "softly").distinct();
        Optional<String> largest = words.max(String::compareToIgnoreCase);
        System.out.println("largest: " + largest.orElse(""));

        words = Stream.of("merrily", "merrily", "gently", "softly").distinct();
        Optional<String> startsWithQ = words.filter(s -> s.startsWith("Q")).findFirst();
        System.out.println(startsWithQ.orElse("NOT FOUND"));
    }
}
