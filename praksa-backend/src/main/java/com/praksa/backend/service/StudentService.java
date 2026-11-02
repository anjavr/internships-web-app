package com.praksa.backend.service;

import com.praksa.backend.dto.StudentDTO;
import com.praksa.backend.entity.Company;
import com.praksa.backend.entity.Role;
import com.praksa.backend.entity.Student;
import com.praksa.backend.entity.User;
import com.praksa.backend.mapper.StudentMapper;
import com.praksa.backend.repository.StudentRepository;
import com.praksa.backend.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class StudentService {

    private final StudentRepository studentRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public StudentService(StudentRepository studentRepository, UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.studentRepository = studentRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    //create
    @Transactional
    public StudentDTO create(StudentDTO studentDTO) {

        User user = new User();
        user.setId(UUID.randomUUID().toString());
        user.setUsername(studentDTO.getUsername());
        user.setPasswordHash(passwordEncoder.encode(studentDTO.getPassword()));
        user.setEmail(studentDTO.getEmail());
        user.setRole(Role.STUDENT);
        user.setActive(true);

        Student student = StudentMapper.toEntity(studentDTO);
        student.setUser(user);

        return StudentMapper.toDTO(studentRepository.save(student));
    }

    //read
    @Transactional
    public List<StudentDTO> getAll(){
        return studentRepository.findAll()
                .stream().map(StudentMapper::toDTO).collect(Collectors.toList());
    }

    //read by id
    @Transactional
    public StudentDTO getById(String id) {
        Student student = studentRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Student not found"));
        return StudentMapper.toDTO(student);
    }

    //update
    @Transactional
    public StudentDTO update(String id, StudentDTO studentDTO){
        Student student = studentRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Student not found"));
        student.setFullName(studentDTO.getFullName());
        student.setAddress(studentDTO.getAddress());
        student.setPhone(studentDTO.getPhone());
        student.setSummary(studentDTO.getSummary());
        student.setEuropassJson(studentDTO.getEuropassJson());
        student.setPhotoPath(studentDTO.getPhotoPath());

        User user = student.getUser();
        if (studentDTO.getEmail() != null) user.setEmail(studentDTO.getEmail());
        if (studentDTO.getUsername() != null) user.setUsername(studentDTO.getUsername());

        return StudentMapper.toDTO(studentRepository.save(student));
    }

    //delete
    @Transactional
    public void deleteById(String id) {
        studentRepository.deleteById(id);
    }

    //upload photo
    public String uploadPhoto(String id, MultipartFile file) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        try {
            String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
            Path uploadPath = Paths.get("uploads/photos");
            System.out.println("UPLOAD PATH: " + uploadPath.toAbsolutePath());
            Files.createDirectories(uploadPath);
            Files.copy(file.getInputStream(), uploadPath.resolve(filename));

            student.setPhotoPath("uploads/photos/" + filename);
            studentRepository.save(student);
            return student.getPhotoPath();
        } catch (IOException e) {
            throw new RuntimeException("Greška pri uploadu slike");
        }
    }

    //deactivate
    @Transactional
    public void setActive(String id, boolean active) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        student.getUser().setActive(active);
        studentRepository.save(student);
    }

    //read CSV file
    @Transactional
    public void uploadCsv(MultipartFile file) {
        System.out.println("FILE NAME: " + file.getOriginalFilename());
        System.out.println("FILE SIZE: " + file.getSize());

        try (BufferedReader reader =
                     new BufferedReader(
                             new InputStreamReader(file.getInputStream(),
                                     java.nio.charset.StandardCharsets.UTF_8))) {

            String line;
            reader.readLine();

            while ((line = reader.readLine()) != null) {
                System.out.println("LINE: " + line);
                String[] data = line.split(";");
                System.out.println("DATA LENGTH: " + data.length);

                StudentDTO dto = new StudentDTO();
                dto.setFullName(data[0]);
                dto.setEmail(data[1]);
                dto.setUsername(data[2]);
                dto.setPassword(data[3]);
                dto.setPhone(data[4]);
                dto.setAddress(data.length > 5 ? data[5] : "");
                create(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error while reading CSV file.");
        }
    }
}
