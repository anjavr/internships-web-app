package com.praksa.backend.service;

import com.praksa.backend.dto.InternshipDTO;
import com.praksa.backend.entity.Company;
import com.praksa.backend.entity.Internship;
import com.praksa.backend.mapper.InternshipMapper;
import com.praksa.backend.repository.CompanyRepository;
import com.praksa.backend.repository.InternshipRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class InternshipService {

    private final InternshipRepository internshipRepository;
    private final CompanyRepository companyRepository;

    public InternshipService(InternshipRepository internshipRepository,
                             CompanyRepository companyRepository) {
        this.internshipRepository = internshipRepository;
        this.companyRepository = companyRepository;
    }

    private String toJsonArray(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        if (value.trim().startsWith("[")) {
            return value;
        }
        String[] parts = value.split(",");
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < parts.length; i++) {
            sb.append("\"").append(parts[i].trim()).append("\"");
            if (i < parts.length - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    // create
    @Transactional
    public InternshipDTO create(InternshipDTO internshipDTO) {
        Company company = companyRepository.findById(internshipDTO.getCompanyId())
                .orElseThrow(() -> new RuntimeException("Company not found"));

        Internship internship = InternshipMapper.toEntity(internshipDTO);
        internship.setId(UUID.randomUUID().toString());
        internship.setCompany(company);
        internship.setCreatedAt(LocalDateTime.now());
        internship.setUpdatedAt(LocalDateTime.now());
        internship.setTakenpositions(0);
        internship.setIsActive(true);
        internship.setApplicationDeadline(internshipDTO.getApplicationDeadline());

        internship.setTechnologies(toJsonArray(internshipDTO.getTechnologies()));
        internship.setRequiredLanguages(toJsonArray(internshipDTO.getRequiredLanguages()));
        internship.setAdditionalRequirements(
                toJsonArray(internshipDTO.getAdditionalRequirements()));

        return InternshipMapper.toDTO(internshipRepository.save(internship));
    }

    // read
    public List<InternshipDTO> getAll() {
        return internshipRepository.findByIsActiveTrueAndStartDateAfter(LocalDate.now())
                .stream()
                .map(InternshipMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<InternshipDTO> getAllForFaculty() {
        return internshipRepository.findAll()
                .stream()
                .map(InternshipMapper::toDTO)
                .collect(Collectors.toList());
    }

    public InternshipDTO getById(String id) {
        Internship internship = internshipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        return InternshipMapper.toDTO(internship);
    }

    // read by company
    public List<InternshipDTO> getByCompany(String companyId) {
        Company company = companyRepository.findById(companyId)
                .orElseThrow(() -> new RuntimeException("Company not found"));
        return internshipRepository.findByCompany(company)
                .stream()
                .map(InternshipMapper::toDTO)
                .collect(Collectors.toList());
    }

    // update
    @Transactional
    public InternshipDTO update(String id, InternshipDTO internshipDTO) {
        Internship internship = internshipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Internship not found"));

        internship.setTitle(internshipDTO.getTitle());
        internship.setShortDesc(internshipDTO.getShortDesc());
        internship.setDescription(internshipDTO.getDescription());
        internship.setRequirements(internshipDTO.getRequirements());
        internship.setMinGpa(internshipDTO.getMinGpa());
        internship.setRequiredYear(internshipDTO.getRequiredYear());
        internship.setStartDate(internshipDTO.getStartDate());
        internship.setEndDate(internshipDTO.getEndDate());
        internship.setPositions(internshipDTO.getPositions());
        internship.setLocation(internshipDTO.getLocation());
        internship.setWorkType(internshipDTO.getWorkType());
        internship.setUpdatedAt(LocalDateTime.now());
        internship.setApplicationDeadline(internshipDTO.getApplicationDeadline());

        internship.setTechnologies(toJsonArray(internshipDTO.getTechnologies()));
        internship.setRequiredLanguages(toJsonArray(internshipDTO.getRequiredLanguages()));
        internship.setAdditionalRequirements(
                toJsonArray(internshipDTO.getAdditionalRequirements()));

        return InternshipMapper.toDTO(internshipRepository.save(internship));
    }

    // delete
    @Transactional
    public void deleteById(String id) {
        internshipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        internshipRepository.deleteById(id);
    }

    // activate/deactivate
    @Transactional
    public InternshipDTO setActive(String id, boolean active) {
        Internship internship = internshipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        internship.setIsActive(active);
        internship.setUpdatedAt(LocalDateTime.now());
        return InternshipMapper.toDTO(internshipRepository.save(internship));
    }

    public boolean canEvaluate(Internship internship) {
        return internship.getEndDate().isBefore(LocalDate.now());
    }
}