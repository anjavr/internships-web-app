package com.praksa.backend.repository;

import com.praksa.backend.entity.WorkLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WorkLogRepository extends JpaRepository<WorkLog, String> {

    List<WorkLog> findByStudentId(String studentId);
    List<WorkLog> findByDiaryId(String diaryId);
    List<WorkLog> findByInternshipId(String internshipId);
}