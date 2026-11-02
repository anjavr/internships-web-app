package com.praksa.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class InternshipDTO {
    private String id;
    private String companyId;
    private String title;
    private String shortDesc;
    private String description;
    private String technologies;
    private String requirements;
    private String minGpa;
    private String requiredYear;
    private String requiredLanguages;
    private String additionalRequirements;
    private String startDate;
    private String endDate;
    private Integer positions;
    private Integer takenPositions;
    private String location;
    private String workType;
    private boolean isActive;
    private String applicationDeadline;
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getShortDesc() {
        return shortDesc;
    }

    public void setShortDesc(String shortDesc) {
        this.shortDesc = shortDesc;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTechnologies() {
        return technologies;
    }

    public void setTechnologies(String technologies) {
        this.technologies = technologies;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getMinGpa() {
        return minGpa;
    }

    public void setMinGpa(String minGpa) {
        this.minGpa = minGpa;
    }

    public String getRequiredYear() {
        return requiredYear;
    }

    public void setRequiredYear(String requiredYear) {
        this.requiredYear = requiredYear;
    }

    public String getRequiredLanguages() {
        return requiredLanguages;
    }

    public void setRequiredLanguages(String requiredLanguages) {
        this.requiredLanguages = requiredLanguages;
    }

    public String getAdditionalRequirements() {
        return additionalRequirements;
    }

    public void setAdditionalRequirements(String additionalRequirements) {
        this.additionalRequirements = additionalRequirements;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Integer getPositions() {
        return positions;
    }

    public void setPositions(Integer positions) {
        this.positions = positions;
    }

    public Integer getTakenPositions() {
        return takenPositions;
    }

    public void setTakenPositions(Integer takenPositions) {
        this.takenPositions = takenPositions;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWorkType() {
        return workType;
    }

    public void setWorkType(String workType) {
        this.workType = workType;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getApplicationDeadline() {
        return applicationDeadline;
    }

    public void setApplicationDeadline(String applicationDeadline) {
        this.applicationDeadline = applicationDeadline;
    }
}