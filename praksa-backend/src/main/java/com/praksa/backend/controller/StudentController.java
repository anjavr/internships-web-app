package com.praksa.backend.controller;

import com.praksa.backend.dto.StudentDTO;
import com.praksa.backend.service.StudentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @PostMapping
    public StudentDTO create(@RequestBody StudentDTO studentDTO) {
        return studentService.create(studentDTO);
    }

    @GetMapping
    public List<StudentDTO> getAll() {
        return studentService.getAll();
    }

    @GetMapping("/{id}")
    public StudentDTO getById(@PathVariable String id) {
        return studentService.getById(id);
    }

    @PutMapping("/{id}")
    public StudentDTO update(@RequestBody StudentDTO studentDTO, @PathVariable String id) {
        return studentService.update(id, studentDTO);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) {
        studentService.deleteById(id);
    }

    @PostMapping("/{id}/photo")
    public ResponseEntity<String> uploadPhoto(@PathVariable String id,
                                              @RequestParam("file") MultipartFile file) {
        String path = studentService.uploadPhoto(id, file);
        return ResponseEntity.ok(path);
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadCsv(
            @RequestParam("file") MultipartFile file) {

        studentService.uploadCsv(file);

        return ResponseEntity.ok().build();
    }
}
