package com.praksa.backend.mapper;

import com.praksa.backend.dto.CompanyDTO;
import com.praksa.backend.entity.Company;

public class CompanyMapper {

    public static CompanyDTO toDTO(Company company) {
        CompanyDTO dto = new CompanyDTO();
        dto.setId(company.getId());
        dto.setName(company.getName());
        dto.setDescription(company.getDescription());
        dto.setAddress(company.getAddress());
        dto.setContactEmail(company.getContactEmail());
        dto.setContactPhone(company.getContactPhone());
        dto.setActive(company.getUser().isActive());
        return dto;
    }

    public static Company toEntity(CompanyDTO dto) {
        Company company = new Company();
        company.setId(dto.getId());
        company.setName(dto.getName());
        company.setDescription(dto.getDescription());
        company.setAddress(dto.getAddress());
        company.setContactEmail(dto.getContactEmail());
        company.setContactPhone(dto.getContactPhone());
        return company;
    }
}
