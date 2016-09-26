package com.mathackers.fundamental;

/**
 * Created by andersc on 9/25/16.
 */
public class VariableArgs {
    private static double average(double... values) {
        double sum = 0;
        for (double v : values) {
            sum += v;
        }
        return values.length == 0 ? 0 : sum / values.length;
    }

    public static void main(String[] args) {
        System.out.println(average(3, 4.5, 10, 0));
    }
}
