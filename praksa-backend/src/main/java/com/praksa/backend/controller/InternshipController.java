package com.praksa.backend.controller;

import com.praksa.backend.dto.InternshipDTO;
import com.praksa.backend.service.InternshipService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/internships")
public class InternshipController {

    private final InternshipService internshipService;

    public InternshipController(InternshipService internshipService) {
        this.internshipService = internshipService;
    }

    @GetMapping
    public ResponseEntity<List<InternshipDTO>> getAll() {
        return ResponseEntity.ok(internshipService.getAll());
    }

    @GetMapping("/all")
    public ResponseEntity<List<InternshipDTO>> getAllForFaculty() {
        return ResponseEntity.ok(internshipService.getAllForFaculty());
    }

    @GetMapping("/{id}")
    public ResponseEntity<InternshipDTO> getById(@PathVariable String id) {
        return ResponseEntity.ok(internshipService.getById(id));
    }

    @GetMapping("/company/{companyId}")
    public ResponseEntity<List<InternshipDTO>> getByCompany(@PathVariable String companyId) {
        return ResponseEntity.ok(internshipService.getByCompany(companyId));
    }

    @PostMapping
    public ResponseEntity<InternshipDTO> create(@RequestBody InternshipDTO internshipDTO) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(internshipService.create(internshipDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<InternshipDTO> update(@PathVariable String id,
                                                @RequestBody InternshipDTO internshipDTO) {
        return ResponseEntity.ok(internshipService.update(id, internshipDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        internshipService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/active")
    public ResponseEntity<InternshipDTO> setActive(@PathVariable String id,
                                                   @RequestParam boolean active) {
        return ResponseEntity.ok(internshipService.setActive(id, active));
    }
}