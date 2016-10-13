package com.mathackers.collections;

import java.util.Properties;

/**
 * Created by andersc on 10/5/16.
 */
public class SysProps {
    public static void main(String[] args) {
        Properties sysProps = System.getProperties();
        for (Object key: sysProps.keySet()) {
            System.out.println(key + ": " + sysProps.getProperty((String)key));
        }
    }
}
