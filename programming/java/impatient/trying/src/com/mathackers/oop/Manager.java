package com.mathackers.oop;

/**
 * Created by andersc on 10/3/16.
 */
public class Manager extends Employee {

    private double bonus;

    public Manager(String name, double salary) {
        super(name, salary);
        bonus = 0;
    }

    public void setBonus(double bonus) {
        this.bonus = bonus;
    }

    @Override
    public double getSalary() {
        return super.getSalary() + bonus;
    }
}
