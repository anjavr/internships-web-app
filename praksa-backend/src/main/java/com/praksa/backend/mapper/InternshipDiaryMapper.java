package com.praksa.backend.mapper;

import com.praksa.backend.dto.InternshipDiaryDTO;
import com.praksa.backend.entity.InternshipDiary;

public class InternshipDiaryMapper {

    public static InternshipDiaryDTO toDTO(InternshipDiary diary) {
        InternshipDiaryDTO dto = new InternshipDiaryDTO();
        dto.setId(diary.getId());
        dto.setStatus(diary.getStatus());
        dto.setSubmittedAt(diary.getSubmittedAt());
        dto.setCreatedAt(diary.getCreatedAt());

        if (diary.getStudent() != null) {
            dto.setStudentId(diary.getStudent().getId());
            dto.setStudentName(diary.getStudent().getFullName());
        }

        if (diary.getInternship() != null) {
            dto.setInternshipId(diary.getInternship().getId());
            dto.setInternshipTitle(diary.getInternship().getTitle());
            if (diary.getInternship().getCompany() != null) {
                dto.setCompanyName(diary.getInternship().getCompany().getName());
            }
        }

        return dto;
    }
}