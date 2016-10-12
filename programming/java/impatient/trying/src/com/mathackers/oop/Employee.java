package com.mathackers.oop;

/**
 * @author: andersc
 */
public class Employee {
    private final String name;
    private double salary;

    public Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    public Employee(double salary) {
        this("", salary);
    }

    public double getSalary() {
        return salary;
    }

    public void raiseSalary(double byPercent) {
        salary += salary * byPercent / 100;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return getClass().getName() + "[name=" + name
                + ", salary=" + salary + "]";
    }

    public static void main(String[] args) {
        Employee emp = new Employee("bill", 100);
        System.out.println(emp);
    }
}
