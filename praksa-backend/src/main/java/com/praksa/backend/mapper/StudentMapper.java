package com.praksa.backend.mapper;

import com.praksa.backend.dto.StudentDTO;
import com.praksa.backend.entity.Student;
import java.util.stream.Collectors;

public class StudentMapper {

    public static StudentDTO toDTO(Student student) {
        StudentDTO dto = new StudentDTO();
        dto.setId(student.getId());
        dto.setFullName(student.getFullName());
        dto.setAddress(student.getAddress());
        dto.setPhone(student.getPhone());
        dto.setSummary(student.getSummary());
        dto.setEuropassJson((student.getEuropassJson()));
        dto.setPhotoPath(student.getPhotoPath());

        if (student.getUser() != null) {
            dto.setUsername(student.getUser().getUsername());
            dto.setEmail(student.getUser().getEmail());
        }

        if (student.getSkills() != null) {
            dto.setSkills(student.getSkills()
                    .stream()
                    .map(SkillMapper::toDTO)
                    .collect(Collectors.toList()));
        }

        if (student.getInterests() != null) {
            dto.setInterests(student.getInterests()
                    .stream()
                    .map(InterestMapper::toDTO)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    public static Student toEntity(StudentDTO dto) {
        Student student = new Student();
        student.setId(dto.getId());
        student.setFullName(dto.getFullName());
        student.setAddress(dto.getAddress());
        student.setPhone(dto.getPhone());
        student.setSummary(dto.getSummary());
        student.setEuropassJson(dto.getEuropassJson());
        student.setPhotoPath(dto.getPhotoPath());
        return student;
    }
}
