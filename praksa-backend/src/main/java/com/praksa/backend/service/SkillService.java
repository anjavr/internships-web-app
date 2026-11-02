package com.praksa.backend.service;

import com.praksa.backend.dto.SkillDTO;
import com.praksa.backend.entity.Skill;
import com.praksa.backend.entity.Student;
import com.praksa.backend.mapper.SkillMapper;
import com.praksa.backend.repository.SkillRepository;
import com.praksa.backend.repository.StudentRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class SkillService {

    private final SkillRepository skillRepository;
    private final StudentRepository studentRepository;

    public SkillService(SkillRepository skillRepository, StudentRepository studentRepository) {
        this.skillRepository = skillRepository;
        this.studentRepository = studentRepository;
    }

    //create
    @Transactional
    public SkillDTO create( String studentId,SkillDTO skillDTO) {
        Student student = studentRepository.findById(studentId).
                orElseThrow(() -> new RuntimeException("Student not found"));

        Skill skill = new Skill();
        skill.setId(UUID.randomUUID().toString());
        skill.setName(skillDTO.getName());
        skill.setLevel(skillDTO.getLevel());
        skill.setStudent(student);

        return SkillMapper.toDTO(skillRepository.save(skill));
    }

    //read
    //get all skills for one student
    @Transactional
    public List<SkillDTO> getAllByStudent(String studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        return student.getSkills()
                .stream()
                .map(SkillMapper::toDTO)
                .collect(Collectors.toList());
    }

    //delete
    @Transactional
    public void delete(String studentId, String skillId) {
        Skill skill = skillRepository.findById(skillId)
                .orElseThrow(() -> new RuntimeException("Skill not found"));
        if (!skill.getStudent().getId().equals(studentId)) {
            throw new RuntimeException("Skill does not belong to this student");
        }
        skillRepository.deleteById(skillId);
    }
}
