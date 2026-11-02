package com.praksa.backend.dto;

import java.time.LocalDate;

public class WorkLogDTO {

    private String id;
    private String studentId;
    private String studentName;
    private String internshipId;

    private LocalDate weekStartDate;
    private String activities;
    private Integer hours;
    private String supervisorFeedback;
    private String createdAt;
    private String diaryId;

    // getters i setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getInternshipId() {
        return internshipId;
    }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public void setInternshipId(String internshipId) {
        this.internshipId = internshipId;
    }

    public LocalDate getWeekStartDate() {
        return weekStartDate;
    }

    public void setWeekStartDate(LocalDate weekStartDate) {
        this.weekStartDate = weekStartDate;
    }

    public String getActivities() {
        return activities;
    }

    public void setActivities(String activities) {
        this.activities = activities;
    }

    public Integer getHours() {
        return hours;
    }

    public void setHours(Integer hours) {
        this.hours = hours;
    }

    public String getSupervisorFeedback() {
        return supervisorFeedback;
    }

    public void setSupervisorFeedback(String supervisorFeedback) {
        this.supervisorFeedback = supervisorFeedback;
    }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getDiaryId() {
        return diaryId;
    }

    public void setDiaryId(String diaryId) {
        this.diaryId = diaryId;
    }
}