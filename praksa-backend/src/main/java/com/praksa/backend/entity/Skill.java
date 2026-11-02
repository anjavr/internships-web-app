package com.praksa.backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "skills",
        uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "name"}))
public class Skill {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "name")
    private String name;

    @Column(name = "level")
    private String level;

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

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getLevel() {
        return level;
    }
}
