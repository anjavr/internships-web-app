package com.praksa.backend.repository;

import com.praksa.backend.entity.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface EvaluationRepository extends JpaRepository<Evaluation, String> {
    List<Evaluation> findByStudentId(String studentId);
    List<Evaluation> findByInternshipId(String internshipId);
    Optional<Evaluation> findByStudentIdAndInternshipId(
            String studentId, String internshipId);
}