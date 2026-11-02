package com.praksa.backend.controller;

import com.praksa.backend.dto.ApplicationDTO;
import com.praksa.backend.entity.ApplicationStatus;
import com.praksa.backend.service.ApplicationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/applications")
public class ApplicationController {

    private final ApplicationService applicationService;

    public ApplicationController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping
    public ResponseEntity<ApplicationDTO> create(@RequestBody ApplicationDTO applicationDTO) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(applicationService.create(applicationDTO));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<ApplicationDTO>> getByStudent(@PathVariable String studentId) {
        return ResponseEntity.ok(applicationService.getByStudent(studentId));
    }

    @GetMapping("/accepted")
    public ResponseEntity<List<ApplicationDTO>> getAccepted() {
        return ResponseEntity.ok(applicationService.getAccepted());
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<ApplicationDTO> updateStatus(
            @PathVariable String id,
            @RequestParam ApplicationStatus status) {
        return ResponseEntity.ok(applicationService.updateStatus(id, status));
    }

    @GetMapping("/internship/{internshipId}")
    public ResponseEntity<List<ApplicationDTO>> getByInternship(
            @PathVariable String internshipId) {
        return ResponseEntity.ok(applicationService.getByInternship(internshipId));
    }

    @GetMapping("/internship/{internshipId}/accepted")
    public ResponseEntity<List<ApplicationDTO>> getAcceptedByInternship(
            @PathVariable String internshipId) {
        return ResponseEntity.ok(
                applicationService.getAcceptedByInternship(internshipId));
    }
}