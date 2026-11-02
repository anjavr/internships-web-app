package com.praksa.backend.controller;


import com.praksa.backend.dto.InterestDTO;
import com.praksa.backend.service.InterestService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/students/{studentId}/interests")
public class InterestController {

    private final InterestService interestService;

    public InterestController(InterestService interestService) {
        this.interestService = interestService;
    }

    @GetMapping
    public ResponseEntity<List<InterestDTO>> getInterests(@PathVariable String studentId) {
        return ResponseEntity.ok(interestService.getAllByStudent(studentId));
    }

    @PostMapping
    public ResponseEntity<InterestDTO> createInterest(@PathVariable String studentId,
                                                      @RequestBody InterestDTO interestDTO) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(interestService.create( studentId, interestDTO));
    }

    @DeleteMapping("/{interestId}")
    public ResponseEntity<Void> delete(@PathVariable String studentId, @PathVariable String interestId) {
        interestService.delete(studentId, interestId);
        return ResponseEntity.noContent().build();
    }
}
