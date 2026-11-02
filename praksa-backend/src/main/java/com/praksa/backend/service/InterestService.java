package com.praksa.backend.service;

import com.praksa.backend.dto.InterestDTO;
import com.praksa.backend.entity.Interest;
import com.praksa.backend.entity.Student;
import com.praksa.backend.mapper.InterestMapper;
import com.praksa.backend.repository.InterestRepository;
import com.praksa.backend.repository.StudentRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class InterestService {

    private final InterestRepository interestRepository;
    private final StudentRepository studentRepository;

    public InterestService(InterestRepository interestRepository, StudentRepository studentRepository){
        this.interestRepository = interestRepository;
        this.studentRepository = studentRepository;
    }

    //create
    @Transactional
    public InterestDTO create(String studentId, InterestDTO interestDTO){
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        Interest interest = new Interest();
        interest.setId(UUID.randomUUID().toString());
        interest.setName(interestDTO.getName());
        interest.setStudent(student);

        return InterestMapper.toDTO(interestRepository.save(interest));
    }

    //read
    @Transactional
    public List<InterestDTO> getAllByStudent(String studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        return student.getInterests()
                .stream()
                .map(InterestMapper::toDTO)
                .collect(Collectors.toList());
    }

    //delete
    @Transactional
    public void delete(String studentId, String interestId) {
        Interest interest = interestRepository.findById(interestId)
                .orElseThrow(() -> new RuntimeException("Interest not found"));

        if (!interest.getStudent().getId().equals(studentId)) {
            throw new RuntimeException("Interest does not belong to this student");
        }

        interestRepository.deleteById(interestId);
    }
}
