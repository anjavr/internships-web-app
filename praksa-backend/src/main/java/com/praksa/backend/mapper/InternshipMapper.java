package com.praksa.backend.mapper;

import com.praksa.backend.dto.InternshipDTO;
import com.praksa.backend.entity.Internship;

import java.time.LocalDateTime;

public class InternshipMapper {

    // JSON array ["Java","Spring"] → "Java, Spring"
    private static String fromJsonArray(String json) {
        if (json == null || json.trim().isEmpty()) {
            return "";
        }
        if (!json.trim().startsWith("[")) {
            return json;
        }
        return json
                .replace("[", "")
                .replace("]", "")
                .replace("\"", "")
                .trim();
    }

    public static InternshipDTO toDTO(Internship internship) {
        InternshipDTO dto = new InternshipDTO();
        dto.setId(internship.getId());
        dto.setTitle(internship.getTitle());
        dto.setShortDesc(internship.getShortDesc());
        dto.setDescription(internship.getDescription());
        dto.setTechnologies(fromJsonArray(internship.getTechnologies()));
        dto.setRequirements(internship.getRequirements());
        dto.setMinGpa(internship.getMinGpa());
        dto.setRequiredYear(internship.getRequiredYear());
        dto.setRequiredLanguages(fromJsonArray(internship.getRequiredLanguages()));
        dto.setAdditionalRequirements(fromJsonArray(internship.getAdditionalRequirements()));
        dto.setStartDate(internship.getStartDate());
        dto.setEndDate(internship.getEndDate());
        dto.setPositions(internship.getPositions());
        dto.setTakenPositions(internship.getTakenpositions());
        dto.setLocation(internship.getLocation());
        dto.setWorkType(internship.getWorkType());
        dto.setIsActive(internship.getIsActive());
        dto.setCreatedAt(internship.getCreatedAt());
        dto.setUpdatedAt(internship.getUpdatedAt());
        dto.setApplicationDeadline(internship.getApplicationDeadline());

        if (internship.getCompany() != null) {
            dto.setCompanyId(internship.getCompany().getId());
            dto.setCompanyName(internship.getCompany().getName());
        }

        return dto;
    }

    public static Internship toEntity(InternshipDTO dto) {
        Internship internship = new Internship();
        internship.setTitle(dto.getTitle());
        internship.setShortDesc(dto.getShortDesc());
        internship.setDescription(dto.getDescription());
        internship.setTechnologies(dto.getTechnologies());
        internship.setRequirements(dto.getRequirements());
        internship.setMinGpa(dto.getMinGpa());
        internship.setRequiredYear(dto.getRequiredYear());
        internship.setRequiredLanguages(dto.getRequiredLanguages());
        internship.setAdditionalRequirements(dto.getAdditionalRequirements());
        internship.setStartDate(dto.getStartDate());
        internship.setEndDate(dto.getEndDate());
        internship.setPositions(dto.getPositions());
        internship.setTakenpositions(dto.getTakenPositions());
        internship.setLocation(dto.getLocation());
        internship.setWorkType(dto.getWorkType());
        internship.setIsActive(dto.getIsActive());
        internship.setCreatedAt(LocalDateTime.now());
        internship.setUpdatedAt(LocalDateTime.now());
        internship.setApplicationDeadline(dto.getApplicationDeadline());
        return internship;
    }
}
