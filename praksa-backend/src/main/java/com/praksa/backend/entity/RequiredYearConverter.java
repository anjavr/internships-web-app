package com.praksa.backend.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class RequiredYearConverter
        implements AttributeConverter<RequiredYear, String> {

    @Override
    public String convertToDatabaseColumn(RequiredYear attribute) {
        if (attribute == null) return null;
        return attribute.getValue();
    }

    @Override
    public RequiredYear convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;
        return RequiredYear.fromValue(dbData);
    }
}