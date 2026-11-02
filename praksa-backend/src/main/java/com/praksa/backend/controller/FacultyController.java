package com.praksa.backend.controller;

import com.praksa.backend.dto.FacultyDTO;
import com.praksa.backend.service.FacultyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/faculties")
public class FacultyController {

    private final FacultyService facultyService;

    public FacultyController(FacultyService facultyService) {
        this.facultyService = facultyService;
    }

    @PostMapping
    public ResponseEntity<FacultyDTO> create(@RequestBody FacultyDTO facultyDTO) {
        return ResponseEntity.status(HttpStatus.CREATED).body(facultyService.create(facultyDTO));
    }

    @GetMapping
    public ResponseEntity<List<FacultyDTO>> getAll() {
        return ResponseEntity.ok(facultyService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<FacultyDTO> getById(@PathVariable String id) {
        return ResponseEntity.ok(facultyService.getById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FacultyDTO> update(@PathVariable String id, @RequestBody FacultyDTO facultyDTO) {
        return ResponseEntity.ok(facultyService.update(id, facultyDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        facultyService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}