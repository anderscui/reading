package com.mathackers.oop;

import java.util.Objects;

/**
 * Created by andersc on 10/4/16.
 */
public class EqualityItem {
    private String description;
    private double price;

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }

        if (other == null) {
            // because "this" must not be null
            return false;
        }

        if (getClass() != other.getClass()) {
            return false;
        }

        EqualityItem otherItem = (EqualityItem) other;
        return Objects.equals(description, otherItem.description)
                && price == otherItem.price;
    }


}
