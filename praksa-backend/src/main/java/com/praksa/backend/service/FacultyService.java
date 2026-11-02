package com.praksa.backend.service;

import com.praksa.backend.dto.FacultyDTO;
import com.praksa.backend.dto.StudentDTO;
import com.praksa.backend.entity.Faculty;
import com.praksa.backend.entity.Role;
import com.praksa.backend.entity.Student;
import com.praksa.backend.entity.User;
import com.praksa.backend.mapper.FacultyMapper;
import com.praksa.backend.mapper.StudentMapper;
import com.praksa.backend.repository.FacultyRepository;
import com.praksa.backend.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class FacultyService {

    private final FacultyRepository facultyRepository;
    private final UserRepository userRepository;

    public FacultyService(FacultyRepository facultyRepository, UserRepository userRepository) {
        this.facultyRepository = facultyRepository;
        this.userRepository = userRepository;
    }

    //create
    @Transactional
    public FacultyDTO create(FacultyDTO facultyDTO) {
        User user = new User();
        user.setId(UUID.randomUUID().toString());
        user.setUsername(facultyDTO.getUsername());
        user.setPasswordHash(facultyDTO.getPassword());
        user.setEmail(facultyDTO.getEmail());
        user.setRole(Role.FACULTY);
        user.setActive(true);

        Faculty faculty = FacultyMapper.toEntity(facultyDTO);
        faculty.setUser(user);

        return FacultyMapper.toDTO(facultyRepository.save(faculty));
    }

    //read
    public List<FacultyDTO> getAll(){
        return facultyRepository.findAll()
                .stream().map(FacultyMapper::toDTO).collect(Collectors.toList());
    }

    //read by id
    public FacultyDTO getById(String id) {
        Faculty faculty = facultyRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Faculty not found"));
        return FacultyMapper.toDTO(faculty);
    }

    //update
    @Transactional
    public FacultyDTO update(String id, FacultyDTO facultyDTO){
        Faculty faculty = facultyRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Faculty not found"));
        faculty.setName(facultyDTO.getName());
        faculty.setCode(facultyDTO.getCode());
        faculty.setContactEmail(facultyDTO.getContactEmail());

        User user = faculty.getUser();
        if (facultyDTO.getEmail() != null) user.setEmail(facultyDTO.getEmail());
        if (facultyDTO.getUsername() != null) user.setUsername(facultyDTO.getUsername());

        return FacultyMapper.toDTO(facultyRepository.save(faculty));
    }

    //delete
    @Transactional
    public void deleteById(String id) {
        facultyRepository.deleteById(id);
    }
}
