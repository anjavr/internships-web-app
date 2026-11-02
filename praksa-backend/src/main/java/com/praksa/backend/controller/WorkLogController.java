package com.praksa.backend.controller;

import com.praksa.backend.dto.WorkLogDTO;
import com.praksa.backend.service.WorkLogService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/worklogs")
@CrossOrigin
public class WorkLogController {

    private final WorkLogService workLogService;

    public WorkLogController(WorkLogService workLogService) {
        this.workLogService = workLogService;
    }

    @PutMapping("/{id}")
    public ResponseEntity<WorkLogDTO> fillLog(@PathVariable String id,
                                              @RequestBody WorkLogDTO dto) {
        return ResponseEntity.ok(workLogService.fillLog(id, dto));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<WorkLogDTO>> getByStudent(@PathVariable String studentId) {
        return ResponseEntity.ok(workLogService.getByStudent(studentId));
    }

    @GetMapping("/internship/{internshipId}")
    public ResponseEntity<List<WorkLogDTO>> getByInternship(@PathVariable String internshipId) {
        return ResponseEntity.ok(workLogService.getByInternship(internshipId));
    }

    @GetMapping("/diary/{diaryId}")
    public ResponseEntity<List<WorkLogDTO>> getByDiary(@PathVariable String diaryId) {
        return ResponseEntity.ok(workLogService.getByDiary(diaryId));
    }

    @PatchMapping("/{id}/feedback")
    public ResponseEntity<WorkLogDTO> addFeedback(
            @PathVariable String id,
            @RequestBody Map<String, String> body) {
        return ResponseEntity.ok(workLogService.addFeedback(id, body.get("feedback")));
    }
}