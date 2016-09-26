package com.mathackers.fundamental;

import java.io.Console;
import java.util.Scanner;

/**
 * Created by andersc on 9/25/16.
 */
public class IOs {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.println("What is your name?");
        String name = in.nextLine();
        System.out.println(name);

        // TODO:
        Console terminal = System.console();
        System.out.println(terminal);
        String userName = terminal.readLine();
        System.out.println(userName);
        char[] password = terminal.readPassword();
        System.out.println(password);
    }
}
