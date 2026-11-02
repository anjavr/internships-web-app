package com.praksa.backend.controller;

import com.praksa.backend.dto.CompanyDTO;
import com.praksa.backend.service.CompanyService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/companies")
public class CompanyController {

    private final CompanyService companyService;

    public CompanyController(CompanyService companyService) {
        this.companyService = companyService;
    }

    @PostMapping
    public ResponseEntity<CompanyDTO> create(@RequestBody CompanyDTO companyDTO) {
        return ResponseEntity.ok(companyService.create(companyDTO));
    }

    @GetMapping
    public ResponseEntity<List<CompanyDTO>> getAll() {
        return ResponseEntity.ok(companyService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CompanyDTO> getById(@PathVariable String id) {
        return ResponseEntity.ok(companyService.getById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CompanyDTO> update(@PathVariable String id,
                                             @RequestBody CompanyDTO companyDTO) {
        return ResponseEntity.ok(companyService.update(id, companyDTO));
    }

    @PatchMapping("/{id}/active")
    public ResponseEntity<Void> setActive(@PathVariable String id,
                                          @RequestParam boolean active) {
        companyService.setActive(id, active);
        return ResponseEntity.ok().build();
    }
}