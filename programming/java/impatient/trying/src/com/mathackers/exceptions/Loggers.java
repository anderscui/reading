package com.mathackers.exceptions;

import java.util.logging.Logger;

/**
 * Created by andersc on 10/4/16.
 */
public class Loggers {
    public static void main(String[] args) {
        Logger main = Logger.getGlobal();
        main.info("Entering you app...");

        main.warning("Warning info");
    }
}
