package com.praksa.backend.controller;

import com.praksa.backend.dto.InternshipDiaryDTO;
import com.praksa.backend.service.InternshipDiaryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/diaries")
public class InternshipDiaryController {

    private final InternshipDiaryService diaryService;

    public InternshipDiaryController(InternshipDiaryService diaryService) {
        this.diaryService = diaryService;
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<InternshipDiaryDTO>> getByStudent(@PathVariable String studentId) {
        return ResponseEntity.ok(diaryService.getByStudent(studentId));
    }

    @GetMapping("/internship/{internshipId}")
    public ResponseEntity<List<InternshipDiaryDTO>> getByInternship(@PathVariable String internshipId) {
        return ResponseEntity.ok(diaryService.getByInternship(internshipId));
    }

    @GetMapping("/student/{studentId}/internship/{internshipId}")
    public ResponseEntity<InternshipDiaryDTO> getByStudentAndInternship(
            @PathVariable String studentId,
            @PathVariable String internshipId) {
        return ResponseEntity.ok(diaryService.getByStudentAndInternship(studentId, internshipId));
    }

    @PatchMapping("/{diaryId}/submit")
    public ResponseEntity<InternshipDiaryDTO> submit(@PathVariable String diaryId) {
        return ResponseEntity.ok(diaryService.submit(diaryId));
    }

    @PatchMapping("/{diaryId}/feedback-done")
    public ResponseEntity<InternshipDiaryDTO> markFeedbackDone(@PathVariable String diaryId) {
        return ResponseEntity.ok(diaryService.markFeedbackDone(diaryId));
    }

    @PatchMapping("/{diaryId}/evaluate")
    public ResponseEntity<InternshipDiaryDTO> evaluate(@PathVariable String diaryId) {
        return ResponseEntity.ok(diaryService.evaluate(diaryId));
    }
}