package com.praksa.backend.mapper;

import com.praksa.backend.dto.ApplicationDTO;
import com.praksa.backend.entity.Application;

public class ApplicationMapper {

    public static ApplicationDTO toDTO(Application application) {
        ApplicationDTO dto = new ApplicationDTO();
        dto.setId(application.getId());
        dto.setApplicationStatus(application.getApplicationStatus());
        dto.setAppliedAt(application.getAppliedAt());
        dto.setDecisionAt(application.getDecisionAt());
        dto.setNote(application.getNote());

        if (application.getInternship() != null) {
            dto.setInternshipId(application.getInternship().getId());
            dto.setInternshipTitle(application.getInternship().getTitle());
            dto.setLocation(application.getInternship().getLocation());
            dto.setWorkType(application.getInternship().getWorkType() != null ?
                    application.getInternship().getWorkType().name() : null);
            dto.setStartDate(application.getInternship().getStartDate() != null ?
                    application.getInternship().getStartDate().toString() : null);
            dto.setEndDate(application.getInternship().getEndDate() != null ?
                    application.getInternship().getEndDate().toString() : null);

            if (application.getInternship().getCompany() != null) {
                dto.setCompanyName(application.getInternship().getCompany().getName());
            }
        }

        if (application.getStudent() != null) {
            dto.setStudentId(application.getStudent().getId());
            dto.setStudentName(application.getStudent().getFullName());
        }

        return dto;
    }

    public static Application toEntity(ApplicationDTO dto) {
        Application application = new Application();
        application.setNote(dto.getNote());
        application.setApplicationStatus(dto.getApplicationStatus());
        return application;
    }
}
