package com.praksa.backend.service;

import com.praksa.backend.dto.CompanyDTO;
import com.praksa.backend.entity.Company;
import com.praksa.backend.entity.Role;
import com.praksa.backend.entity.User;
import com.praksa.backend.mapper.CompanyMapper;
import com.praksa.backend.repository.CompanyRepository;
import com.praksa.backend.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CompanyService {

    private final CompanyRepository companyRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public CompanyService(CompanyRepository companyRepository,
                          UserRepository userRepository,
                          PasswordEncoder passwordEncoder) {
        this.companyRepository = companyRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }
    //create
    @Transactional
    public CompanyDTO create(CompanyDTO companyDTO) {
        User user = new User();
        user.setId(UUID.randomUUID().toString());
        user.setUsername(companyDTO.getUsername());
        user.setPasswordHash(passwordEncoder.encode(companyDTO.getPassword()));
        user.setEmail(companyDTO.getEmail());
        user.setRole(Role.COMPANY);
        user.setActive(true);

        Company company = CompanyMapper.toEntity(companyDTO);
        company.setUser(user);
        return CompanyMapper.toDTO(companyRepository.save(company));
    }

    //read
    public List<CompanyDTO> getAll(){
        return companyRepository.findAll().
                stream().map(CompanyMapper::toDTO).collect(Collectors.toList());
    }

    public CompanyDTO getById(String id) {
        Company company = companyRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Company not found"));
        return CompanyMapper.toDTO(company);
    }
    //update
    @Transactional
    public CompanyDTO update(String id, CompanyDTO companyDTO) {
        Company company = companyRepository.findById(id).
                orElseThrow(() -> new RuntimeException("Company not found"));
        company.setName(companyDTO.getName());
        company.setDescription(companyDTO.getDescription());
        company.setAddress(companyDTO.getAddress());
        company.setContactEmail(companyDTO.getContactEmail());
        company.setContactPhone(companyDTO.getContactPhone());

        User user = company.getUser();
        if (companyDTO.getEmail() != null) user.setEmail(companyDTO.getEmail());
        if (companyDTO.getUsername() != null) user.setUsername(companyDTO.getUsername());

        return CompanyMapper.toDTO(companyRepository.save(company));
    }

    //delete
    @Transactional
    public void deleteById(String id) {
        companyRepository.deleteById(id);
    }

    //deactivate
    @Transactional
    public void setActive(String id, boolean active) {
        Company company = companyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Company not found"));
        company.getUser().setActive(active);
        companyRepository.save(company);
    }
}
