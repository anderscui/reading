package com.mathackers.collections;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.Properties;

/**
 * Created by andersc on 10/5/16.
 */
public class PropertiesMap {
    public static void main(String[] args) throws IOException {
        Properties settings = new Properties();
        settings.put("width", "200");
        settings.put("title", "Hello, Java");

//        // TODO: Invalid args.
//        try (OutputStream out = Files.newOutputStream("settings.txt")) {
//            settings.store(out, "Program Properties");
//        }
//
//        // load config file
//        try (InputStream in = Files.newInputStream("settings.txt")) {
//            settings.load(in);
//
//            String title = settings.getProperty("title", "New Document");
//        }

    }
}
