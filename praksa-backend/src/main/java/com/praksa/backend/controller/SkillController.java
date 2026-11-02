package com.praksa.backend.controller;

import com.praksa.backend.dto.SkillDTO;
import com.praksa.backend.service.SkillService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students/{studentId}/skills")
public class SkillController {

    private final SkillService skillService;

    public SkillController(SkillService skillService) {
        this.skillService = skillService;
    }

    @GetMapping
    public ResponseEntity<List<SkillDTO>> getSkills(@PathVariable String studentId) {
        return ResponseEntity.ok(skillService.getAllByStudent(studentId));
    }

    @PostMapping
    public ResponseEntity<SkillDTO> createSkill(@PathVariable String studentId,
                                                @RequestBody SkillDTO skillDTO) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(skillService.create(studentId, skillDTO));
    }

    @DeleteMapping("/{skillId}")
    public ResponseEntity<Void> delete(@PathVariable String studentId, @PathVariable String skillId) {
        skillService.delete(studentId, skillId);
        return ResponseEntity.noContent().build();
    }

}
