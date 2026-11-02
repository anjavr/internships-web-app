package com.praksa.backend.repository;

import com.praksa.backend.entity.Application;
import com.praksa.backend.entity.ApplicationStatus;
import com.praksa.backend.entity.Internship;
import com.praksa.backend.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ApplicationRepository extends JpaRepository<Application, String> {
    List<Application> findByStudent(Student student);
    List<Application> findByInternship(Internship internship);
    List<Application> findByInternshipAndApplicationStatus(Internship internship, ApplicationStatus status);

    Optional<Application> findByStudentAndInternship(
            Student student, Internship internship);

    List<Application> findByApplicationStatus(ApplicationStatus status);

    Optional<Application> findByStudentIdAndInternshipId(
            String studentId, String internshipId);

    List<Application> findByStudentAndApplicationStatus(
            Student student, ApplicationStatus status);
}
