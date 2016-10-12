package com.mathackers.interfaces;

/**
 * Created by andersc on 9/30/16.
 */
public interface IntSequence {

    // static method in an interface
    public static IntSequence digitsOf(int n) {
        return new DigitSequence(n);
    }

    // default method of an interface
    default boolean hasNext() { return false; }
    int next();
}
