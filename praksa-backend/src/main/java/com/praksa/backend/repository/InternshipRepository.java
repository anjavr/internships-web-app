package com.praksa.backend.repository;

import com.praksa.backend.entity.Company;
import com.praksa.backend.entity.Internship;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface InternshipRepository extends JpaRepository<Internship, String> {
    List<Internship> findByCompany(Company company);
    List<Internship> findByIsActiveTrueAndStartDateAfter(LocalDate date);
    List<Internship> findByIsActiveTrue();
}
