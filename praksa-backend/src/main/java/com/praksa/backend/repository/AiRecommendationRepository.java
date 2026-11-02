package com.praksa.backend.repository;

import com.praksa.backend.entity.AiRecommendation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import jakarta.transaction.Transactional;
import java.util.List;

public interface AiRecommendationRepository extends JpaRepository<AiRecommendation, String> {
    List<AiRecommendation> findByStudentIdOrderByScoreDesc(String studentId);

    @Modifying
    @Transactional
    @Query("DELETE FROM AiRecommendation r WHERE r.student.id = :studentId")
    void deleteByStudentId(String studentId);
}