package com.praksa.backend.dto;

import com.praksa.backend.entity.RequiredYear;
import com.praksa.backend.entity.WorkType;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class InternshipDTO {

    private String id;
    private String companyId;
    private String companyName;
    private String title;
    private String shortDesc;
    private String description;
    private String technologies;
    private String requirements;
    private BigDecimal minGpa;
    private RequiredYear requiredYear;
    private String requiredLanguages;
    private String additionalRequirements;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer positions;
    private Integer takenPositions;
    private String location;
    private WorkType workType;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDate applicationDeadline;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setShortDesc(String shortDesc) {
        this.shortDesc = shortDesc;
    }

    public String getShortDesc() {
        return shortDesc;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public void setTechnologies(String technologies) {
        this.technologies = technologies;
    }

    public String getTechnologies() {
        return technologies;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setMinGpa(BigDecimal minGpa) {
        this.minGpa = minGpa;
    }

    public BigDecimal getMinGpa() {
        return minGpa;
    }

    public void setRequiredYear(RequiredYear requiredYear) {
        this.requiredYear = requiredYear;
    }

    public RequiredYear getRequiredYear() {
        return requiredYear;
    }

    public void setRequiredLanguages(String requiredLanguages) {
        this.requiredLanguages = requiredLanguages;
    }

    public String getRequiredLanguages() {
        return requiredLanguages;
    }

    public void setAdditionalRequirements(String additionalRequirements) {
        this.additionalRequirements = additionalRequirements;
    }

    public String getAdditionalRequirements() {
        return additionalRequirements;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setPositions(Integer positions) {
        this.positions = positions;
    }

    public Integer getPositions() {
        return positions;
    }

    public void setTakenPositions(Integer takenPositions) {
        this.takenPositions = takenPositions;
    }

    public Integer getTakenPositions() {
        return takenPositions;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getLocation() {
        return location;
    }

    public void setWorkType(WorkType workType) {
        this.workType = workType;
    }

    public WorkType getWorkType() {
        return workType;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setApplicationDeadline(LocalDate applicationDeadline) {
        this.applicationDeadline = applicationDeadline;
    }

    public LocalDate getApplicationDeadline() {
        return applicationDeadline;
    }
}
