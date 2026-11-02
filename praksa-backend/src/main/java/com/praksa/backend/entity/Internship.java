package com.praksa.backend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "internships")
public class Internship {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "company_id", nullable = false)
    private Company company;

    @Column(nullable = false)
    private String title;

    @Column(name = "short_desc", length = 500)
    private String shortDesc;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "JSON")
    private String technologies;

    @Column(columnDefinition = "TEXT")
    private String requirements;

    @Column(name = "min_gpa", precision = 3, scale = 2)
    private BigDecimal minGpa;

    @Convert(converter = RequiredYearConverter.class)
    @Column(name = "required_year")
    private RequiredYear requiredYear;

    @Column(name = "required_languages", columnDefinition = "JSON")
    private String requiredLanguages;

    @Column(name = "additional_requirements", columnDefinition = "JSON")
    private String additionalRequirements;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "positions")
    private Integer positions;

    @Column(name = "taken_positions")
    private Integer takenPositions;

    @Column(name = "location")
    private String location;

    @Enumerated(EnumType.STRING)
    @Column(name = "work_type")
    private WorkType workType;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "application_deadline")
    private LocalDate applicationDeadline;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setCompany(Company company) {
        this.company = company;
    }

    public Company getCompany() {
        return company;
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

    public void setTakenpositions(Integer takenpositions) {
        this.takenPositions = takenpositions;
    }

    public Integer getTakenpositions() {
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

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsActive() {
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

    public LocalDate getApplicationDeadline() {
        return applicationDeadline;
    }

    public void setApplicationDeadline(LocalDate applicationDeadline) {
        this.applicationDeadline = applicationDeadline;
    }
}
