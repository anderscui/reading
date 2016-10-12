package com.mathackers.oop;

/**
 * Created by andersc on 10/4/16.
 */
public class ClassClass {
    public static void main(String[] args) throws ClassNotFoundException {
        Object o = new Employee("steve", 100);
        Class<?> cl = o.getClass();
        System.out.println("object o is an instance of " + cl.getName());

        // get Class via name
        Class<?> cl2 = Class.forName("com.mathackers.oop.Employee");
        System.out.println(cl2);

        // or
        Class<?> cl3 = com.mathackers.oop.Employee.class;
        System.out.println(cl3);

        // more
        System.out.println(String[].class);
        System.out.println(String[].class.getCanonicalName());
        System.out.println(String[].class.getSimpleName());
        System.out.println(String[].class.getTypeName());
        System.out.println(String[].class.getName());

        System.out.println(int.class);
        System.out.println(void.class);
    }
}
