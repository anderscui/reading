package com.mathackers.generics;

import java.util.ArrayList;

/**
 * Created by andersc on 10/4/16.
 */
public class Generics {
    public static <T extends Runnable & AutoCloseable> void closeAll(ArrayList<T> items)
        throws Exception {
        for (T elem: items)
            elem.close();
    }
}
