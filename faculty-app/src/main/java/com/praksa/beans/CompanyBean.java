package com.praksa.beans;

import com.praksa.dto.CompanyDTO;
import com.praksa.service.CompanyService;
import java.util.List;

public class CompanyBean {

    private List<CompanyDTO> companies;
    private CompanyDTO company;

    private final CompanyService companyService = new CompanyService();

    //getters and setters

    public List<CompanyDTO> getCompanies() { 
    	return companies;
    }
    
    public void setCompanies(List<CompanyDTO> companies) {
    	this.companies = companies;
    }

    public CompanyDTO getCompany() { 
    	return company;
    }
    
    public void setCompany(CompanyDTO company) {
    	this.company = company;
    }

    //service

    public List<CompanyDTO> getAll(String token) {
        this.companies = companyService.getAll(token);
        this.companies.sort((a, b) -> {
            if (a.getName() == null) return 1;
            if (b.getName() == null) return -1;
            return a.getName().compareToIgnoreCase(b.getName());
        });
        return this.companies;
    }

    public CompanyDTO getById(String id, String token) {
        this.company = companyService.getById(id, token);
        return this.company;
    }

    public void create(CompanyDTO company, String token) {
        companyService.create(company, token);
        getAll(token);
    }

    public CompanyDTO update(String id, CompanyDTO company, String token) {
        this.company = companyService.update(id, company, token);
        getAll(token);
        return this.company;
    }

    public void setActive(String id, boolean active, String token) {
        companyService.setActive(id, active, token);
        getAll(token);
    }
}