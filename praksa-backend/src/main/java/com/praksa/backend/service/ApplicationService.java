package com.praksa.backend.service;

import com.praksa.backend.dto.ApplicationDTO;
import com.praksa.backend.entity.Application;
import com.praksa.backend.entity.ApplicationStatus;
import com.praksa.backend.entity.Internship;
import com.praksa.backend.entity.Student;
import com.praksa.backend.mapper.ApplicationMapper;
import com.praksa.backend.repository.ApplicationRepository;
import com.praksa.backend.repository.InternshipRepository;
import com.praksa.backend.repository.StudentRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.time.LocalDateTime;
import java.util.UUID;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ApplicationService {

    private final ApplicationRepository applicationRepository;
    private final StudentRepository studentRepository;
    private final InternshipRepository internshipRepository;
    private final InternshipDiaryService diaryService;

    public ApplicationService(ApplicationRepository applicationRepository,
                              StudentRepository studentRepository,
                              InternshipRepository internshipRepository,
                              InternshipDiaryService diaryService) {
        this.applicationRepository = applicationRepository;
        this.studentRepository = studentRepository;
        this.internshipRepository = internshipRepository;
        this.diaryService = diaryService;
    }

    @Transactional
    public List<ApplicationDTO> getByStudent(String studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        return applicationRepository.findByStudent(student)
                .stream()
                .map(ApplicationMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public ApplicationDTO create(@RequestBody ApplicationDTO applicationDTO) {
        Student student = studentRepository.findById(applicationDTO.getStudentId())
                .orElseThrow(() -> new RuntimeException("Student not found"));
        Internship internship = internshipRepository.findById(applicationDTO.getInternshipId())
                .orElseThrow(() -> new RuntimeException("Internship not found"));

        List<Application> existing = applicationRepository.findByStudent(student);
        boolean alreadyApplied = existing.stream()
                .anyMatch(a -> a.getInternship().getId().equals(applicationDTO.getInternshipId()));
        if (alreadyApplied) {
            throw new RuntimeException("Student već prijavljen na ovu praksu");
        }

        if (internship.getTakenpositions() >= internship.getPositions()) {
            throw new RuntimeException("Nema slobodnih mjesta");
        }

        Application application = new Application();
        application.setId(UUID.randomUUID().toString());
        application.setStudent(student);
        application.setInternship(internship);
        application.setApplicationStatus(ApplicationStatus.APPLIED);
        application.setAppliedAt(LocalDateTime.now());
        application.setNote(applicationDTO.getNote());

        return ApplicationMapper.toDTO(applicationRepository.save(application));
    }

    public List<ApplicationDTO> getAccepted() {
        return applicationRepository
                .findByApplicationStatus(ApplicationStatus.ACCEPTED)
                .stream()
                .map(ApplicationMapper::toDTO)
                .collect(Collectors.toList());
    }

    public ApplicationDTO updateStatus(String id, ApplicationStatus status) {
        System.out.println("UPDATE STATUS CALLED: " + id + " -> " + status);
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found"));

        application.setApplicationStatus(status);
        application.setDecisionAt(LocalDateTime.now());

        if (status == ApplicationStatus.ACCEPTED) {
            System.out.println("CREATING DIARY FOR: " + application.getStudent().getId());
            diaryService.createDiary(
                    application.getStudent().getId(),
                    application.getInternship().getId()
            );
        }

        return ApplicationMapper.toDTO(applicationRepository.save(application));
    }

    public List<ApplicationDTO> getByInternship(String internshipId) {
        Internship internship = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        return applicationRepository.findByInternship(internship)
                .stream()
                .map(ApplicationMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<ApplicationDTO> getAcceptedByInternship(String internshipId) {
        Internship internship = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        return applicationRepository
                .findByInternshipAndApplicationStatus(
                        internship, ApplicationStatus.ACCEPTED)
                .stream()
                .map(ApplicationMapper::toDTO)
                .collect(Collectors.toList());
    }
}