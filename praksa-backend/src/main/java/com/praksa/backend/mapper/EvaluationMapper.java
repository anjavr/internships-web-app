package com.praksa.backend.mapper;

import com.praksa.backend.dto.EvaluationDTO;
import com.praksa.backend.entity.Evaluation;
import com.praksa.backend.entity.Internship;
import com.praksa.backend.entity.Student;
import com.praksa.backend.entity.User;

public class EvaluationMapper {

    public static EvaluationDTO toDTO(Evaluation e) {
        EvaluationDTO dto = new EvaluationDTO();
        dto.setId(e.getId());
        dto.setStudentId(e.getStudent().getId());
        dto.setStudentName(e.getStudent().getFullName());
        dto.setInternshipId(e.getInternship().getId());
        dto.setInternshipTitle(e.getInternship().getTitle());
        dto.setRating(e.getRating());
        dto.setComments(e.getComments());
        if (e.getEvaluator() != null) {
            dto.setEvaluatorId(e.getEvaluator().getId());
        }
        if (e.getCreatedAt() != null) {
            dto.setCreatedAt(e.getCreatedAt().toString());
        }
        return dto;
    }

    public static Evaluation toEntity(EvaluationDTO dto,
                                      Student student, Internship internship, User evaluator) {
        Evaluation e = new Evaluation();
        e.setStudent(student);
        e.setInternship(internship);
        e.setEvaluator(evaluator);
        e.setRating(dto.getRating());
        e.setComments(dto.getComments());
        return e;
    }
}
