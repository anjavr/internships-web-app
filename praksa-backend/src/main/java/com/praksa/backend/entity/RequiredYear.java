package com.praksa.backend.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum RequiredYear {
    _1("1"),
    _2("2"),
    _3("3"),
    _4("4"),
    ANY("ANY");

    private final String value;

    RequiredYear(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @JsonCreator
    public static RequiredYear fromValue(String value) {
        for (RequiredYear year : values()) {
            if (year.value.equals(value)) {
                return year;
            }
        }
        throw new IllegalArgumentException("Unknown value: " + value);
    }
}