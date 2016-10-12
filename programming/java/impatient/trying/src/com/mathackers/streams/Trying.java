package com.mathackers.streams;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

/**
 * Created by andersc on 10/6/16.
 */
public class Trying {
    public static void main(String[] args) throws IOException {
        String contents = new String(Files.readAllBytes(
                Paths.get("alice.txt")), StandardCharsets.UTF_8);
        List<String> words = Arrays.asList(contents.split("\\PL+"));
        System.out.println(words.size() + " words");

        // iterate
        int count = 0;
        for (String w: words) {
            if (w.length() > 12) {
                count++;
            }
        }
        System.out.println(count);

        // with streams
        long count2 = words.stream()
                .filter(w -> w.length() > 12)
                .count();
        System.out.println(count2);

        // parallel stream
        long count3 = words.parallelStream()
                .filter(w -> w.length() > 12)
                .count();
        System.out.println(count3);
    }
}
