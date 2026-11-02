package com.praksa.backend.entity;

import ch.qos.logback.core.util.Loader;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "work_logs",
        uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "internship_id","week_start_date"}))
public class WorkLog {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "internship_id", nullable = false)
    private Internship internship;

    @Column(name = "week_start_date", nullable = false)
    private LocalDate weekStartDate;

    @Column(name = "activities", columnDefinition = "TEXT")
    private String activities;

    @Column(name = "hours")
    private Integer hours;

    @Column(name = "supervisor_feedback", columnDefinition = "TEXT")
    private String supervisorFeedback;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "diary_id")
    private InternshipDiary diary;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Student getStudent() {
        return student;
    }

    public void setInternship(Internship internship) {
        this.internship = internship;
    }

    public Internship getInternship() {
        return internship;
    }

    public void setWeekStartDate(LocalDate weekStartDate) {
        this.weekStartDate = weekStartDate;
    }

    public LocalDate getWeekStartDate() {
        return weekStartDate;
    }

    public void setActivities(String activities) {
        this.activities = activities;
    }

    public String getActivities() {
        return activities;
    }

    public void setHours(Integer hours) {
        this.hours = hours;
    }

    public Integer getHours() {
        return hours;
    }

    public void setSupervisorFeedback(String supervisorFeedback) {
        this.supervisorFeedback = supervisorFeedback;
    }

    public String getSupervisorFeedback() {
        return supervisorFeedback;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public InternshipDiary getDiary() {
        return diary;
    }

    public void setDiary(InternshipDiary diary) {
        this.diary = diary;
    }


}
