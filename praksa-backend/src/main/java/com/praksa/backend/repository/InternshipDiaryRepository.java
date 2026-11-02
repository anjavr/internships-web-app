package com.praksa.backend.repository;

import com.praksa.backend.entity.InternshipDiary;
import com.praksa.backend.entity.DiaryStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface InternshipDiaryRepository extends JpaRepository<InternshipDiary, String> {
    Optional<InternshipDiary> findByStudentIdAndInternshipId(String studentId, String internshipId);
    List<InternshipDiary> findByStudentId(String studentId);
    List<InternshipDiary> findByInternshipId(String internshipId);
    List<InternshipDiary> findByStatus(DiaryStatus status);
}