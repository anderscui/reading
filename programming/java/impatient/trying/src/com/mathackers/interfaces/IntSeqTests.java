package com.mathackers.interfaces;

/**
 * Created by andersc on 9/30/16.
 */
public class IntSeqTests {

    public static double average(IntSequence seq, int n) {
        int count = 0;
        double sum = 0;
        while (seq.hasNext() && count < n) {
            count++;
            sum += seq.next();
        }
        return count == 0 ? 0 : sum / count;
    }

    public static void main(String[] args) {
        IntSequence digits = new DigitSequence(1729);
        double avg = average(digits, 10);
        System.out.println(avg);

        avg = average(digits, 3);
        System.out.println(avg);

        if (digits instanceof DigitSequence) {
            DigitSequence ds = (DigitSequence)digits;
            System.out.println(ds.rest());
        }
    }
}
