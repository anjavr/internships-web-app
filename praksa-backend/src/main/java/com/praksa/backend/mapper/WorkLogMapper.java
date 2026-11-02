package com.praksa.backend.mapper;

import com.praksa.backend.dto.WorkLogDTO;
import com.praksa.backend.entity.WorkLog;
import com.praksa.backend.entity.Student;
import com.praksa.backend.entity.Internship;

public class WorkLogMapper {

    public static WorkLogDTO toDTO(WorkLog entity) {
        WorkLogDTO dto = new WorkLogDTO();
        dto.setId(entity.getId());
        dto.setStudentId(entity.getStudent().getId());
        dto.setStudentName(entity.getStudent().getFullName());
        dto.setInternshipId(entity.getInternship().getId());
        dto.setWeekStartDate(entity.getWeekStartDate());
        dto.setActivities(entity.getActivities());
        dto.setHours(entity.getHours());
        dto.setSupervisorFeedback(entity.getSupervisorFeedback());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(entity.getCreatedAt().toString());
        }
        if (entity.getDiary() != null) {
            dto.setDiaryId(entity.getDiary().getId());
        }
        return dto;
    }

    public static WorkLog toEntity(WorkLogDTO dto, Student student, Internship internship) {
        WorkLog entity = new WorkLog();

        entity.setId(dto.getId());
        entity.setStudent(student);
        entity.setInternship(internship);
        entity.setWeekStartDate(dto.getWeekStartDate());
        entity.setActivities(dto.getActivities());
        entity.setHours(dto.getHours());
        entity.setSupervisorFeedback(dto.getSupervisorFeedback());

        return entity;
    }
}