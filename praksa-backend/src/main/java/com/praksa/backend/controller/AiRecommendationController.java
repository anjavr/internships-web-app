package com.praksa.backend.controller;

import com.praksa.backend.dto.AiRecommendationDTO;
import com.praksa.backend.service.AiRecommendationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
public class AiRecommendationController {

    private final AiRecommendationService service;

    public AiRecommendationController(AiRecommendationService service) {
        this.service = service;
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<AiRecommendationDTO>> getRecommendations(@PathVariable String studentId) {
        return ResponseEntity.ok(service.getRecommendations(studentId));
    }

    @PostMapping("/student/{studentId}/generate")
    public ResponseEntity<List<AiRecommendationDTO>> generateRecommendations(@PathVariable String studentId) {
        return ResponseEntity.ok(service.generateRecommendations(studentId));
    }
}