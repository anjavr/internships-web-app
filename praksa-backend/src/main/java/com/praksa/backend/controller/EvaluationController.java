package com.praksa.backend.controller;

import com.praksa.backend.dto.EvaluationDTO;
import com.praksa.backend.service.EvaluationService;
import com.praksa.backend.util.JwtUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/evaluations")
public class EvaluationController {

    private final EvaluationService evaluationService;
    private final JwtUtil jwtUtil;

    public EvaluationController(EvaluationService evaluationService,
                                JwtUtil jwtUtil) {
        this.evaluationService = evaluationService;
        this.jwtUtil = jwtUtil;
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<EvaluationDTO>> getByStudent(
            @PathVariable String studentId) {
        return ResponseEntity.ok(evaluationService.getByStudent(studentId));
    }

    @GetMapping("/student/{studentId}/internship/{internshipId}")
    public ResponseEntity<EvaluationDTO> getByStudentAndInternship(
            @PathVariable String studentId,
            @PathVariable String internshipId) {
        return ResponseEntity.ok(
                evaluationService.getByStudentAndInternship(
                        studentId, internshipId));
    }

    @PostMapping
    public ResponseEntity<EvaluationDTO> save(
            @RequestBody EvaluationDTO dto,
            @RequestHeader("Authorization") String authHeader) {
        String token = authHeader.substring(7);
        String evaluatorUsername = jwtUtil.extractUsername(token);
        return ResponseEntity.ok(evaluationService.save(dto, evaluatorUsername));
    }
}