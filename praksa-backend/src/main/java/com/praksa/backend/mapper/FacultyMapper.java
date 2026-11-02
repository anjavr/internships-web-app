package com.praksa.backend.mapper;

import com.praksa.backend.dto.FacultyDTO;
import com.praksa.backend.entity.Faculty;

public class FacultyMapper {

    public static FacultyDTO toDTO(Faculty faculty) {
        FacultyDTO dto = new FacultyDTO();
        dto.setId(faculty.getId());
        dto.setName(faculty.getName());
        dto.setCode(faculty.getCode());
        dto.setContactEmail(faculty.getContactEmail());

        if (faculty.getUser() != null) {
            dto.setUsername(faculty.getUser().getUsername());
            dto.setEmail(faculty.getUser().getEmail());
        }

        return dto;
    }

    public static Faculty toEntity(FacultyDTO dto) {
        Faculty faculty = new Faculty();
        faculty.setName(dto.getName());
        faculty.setCode(dto.getCode());
        faculty.setContactEmail(dto.getContactEmail());
        return faculty;
    }

}
