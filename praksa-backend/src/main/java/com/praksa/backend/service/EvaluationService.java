package com.praksa.backend.service;

import com.praksa.backend.dto.EvaluationDTO;
import com.praksa.backend.entity.*;
import com.praksa.backend.repository.EvaluationRepository;
import com.praksa.backend.repository.InternshipRepository;
import com.praksa.backend.repository.StudentRepository;
import com.praksa.backend.repository.UserRepository;
import com.praksa.backend.repository.InternshipDiaryRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class EvaluationService {

    private final EvaluationRepository evaluationRepository;
    private final StudentRepository studentRepository;
    private final InternshipRepository internshipRepository;
    private final UserRepository userRepository;
    private final InternshipDiaryRepository diaryRepository;

    public EvaluationService(EvaluationRepository evaluationRepository,
                             StudentRepository studentRepository,
                             InternshipRepository internshipRepository,
                             UserRepository userRepository,
                             InternshipDiaryRepository diaryRepository) {
        this.evaluationRepository = evaluationRepository;
        this.studentRepository = studentRepository;
        this.internshipRepository = internshipRepository;
        this.userRepository = userRepository;
        this.diaryRepository = diaryRepository;
    }

    public List<EvaluationDTO> getByStudent(String studentId) {
        return evaluationRepository.findByStudentId(studentId)
                .stream().map(this::toDTO).collect(Collectors.toList());
    }

    public EvaluationDTO save(EvaluationDTO dto, String evaluatorUsername) {
        Evaluation evaluation = evaluationRepository
                .findByStudentIdAndInternshipId(
                        dto.getStudentId(), dto.getInternshipId())
                .orElse(new Evaluation());

        Student student = studentRepository.findById(dto.getStudentId())
                .orElseThrow(() -> new RuntimeException("Student not found"));
        Internship internship = internshipRepository.findById(dto.getInternshipId())
                .orElseThrow(() -> new RuntimeException("Internship not found"));
        User evaluator = userRepository.findByUsername(evaluatorUsername)
                .orElseThrow(() -> new RuntimeException("Evaluator not found"));

        if (evaluation.getId() == null) {
            evaluation.setId(UUID.randomUUID().toString());
        }

        evaluation.setStudent(student);
        evaluation.setInternship(internship);
        evaluation.setEvaluator(evaluator);
        evaluation.setRating(dto.getRating());
        evaluation.setComments(dto.getComments());

        diaryRepository.findByStudentIdAndInternshipId(
                        dto.getStudentId(), dto.getInternshipId())
                .ifPresent(diary -> {
                    diary.setStatus(DiaryStatus.EVALUATED);
                    diaryRepository.save(diary);
                });
        
        return toDTO(evaluationRepository.save(evaluation));
    }

    public EvaluationDTO getByStudentAndInternship(
            String studentId, String internshipId) {
        return evaluationRepository
                .findByStudentIdAndInternshipId(studentId, internshipId)
                .map(this::toDTO).orElse(null);
    }

    private EvaluationDTO toDTO(Evaluation e) {
        EvaluationDTO dto = new EvaluationDTO();
        dto.setId(e.getId());
        dto.setStudentId(e.getStudent().getId());
        dto.setStudentName(e.getStudent().getFullName());
        dto.setInternshipId(e.getInternship().getId());
        dto.setInternshipTitle(e.getInternship().getTitle());
        dto.setRating(e.getRating());
        dto.setComments(e.getComments());
        if (e.getCreatedAt() != null) {
            dto.setCreatedAt(e.getCreatedAt().toString());
        }
        return dto;
    }
}