package com.praksa.backend.mapper;

import com.praksa.backend.dto.InterestDTO;
import com.praksa.backend.entity.Interest;

public class InterestMapper {

    public static InterestDTO toDTO(Interest interest) {
        InterestDTO dto = new InterestDTO();
        dto.setId(interest.getId());
        dto.setName(interest.getName());
        return dto;
    }

    public static Interest toInterests(InterestDTO dto) {
        Interest interest = new Interest();
        interest.setId(dto.getId());
        interest.setName(dto.getName());
        return interest;
    }
}
