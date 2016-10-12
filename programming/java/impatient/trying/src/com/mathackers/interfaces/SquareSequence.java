package com.mathackers.interfaces;

/**
 * Created by andersc on 9/30/16.
 */
public class SquareSequence implements IntSequence {

    private int i;

    @Override
    public boolean hasNext() {
        return true;
    }

    @Override
    public int next() {
        i++;
        return i*i;
    }
}

