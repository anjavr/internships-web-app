package com.praksa.backend.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "applications",
            uniqueConstraints = @UniqueConstraint(columnNames = {"internship_id", "student_id"}))
public class Application {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "internship_id", nullable = false)
    private Internship internship;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ApplicationStatus applicationStatus = ApplicationStatus.APPLIED;

    @Column(name = "applied_at", nullable = false,updatable = false)
    private LocalDateTime appliedAt = LocalDateTime.now();

    @Column(name = "decision_at")
    private LocalDateTime decisionAt;

    @Column(columnDefinition = "TEXT")
    private String note;

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

    public void setApplicationStatus(ApplicationStatus applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public ApplicationStatus getApplicationStatus() {
        return applicationStatus;
    }

    public void setDecisionAt(LocalDateTime decisionAt) {
        this.decisionAt = decisionAt;
    }

    public LocalDateTime getDecisionAt() {
        return decisionAt;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getNote() {
        return note;
    }

    public void setAppliedAt(LocalDateTime appliedAt) {
        this.appliedAt = appliedAt;
    }

    public LocalDateTime getAppliedAt() {
        return appliedAt;
    }
}
