package com.praksa.backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "interests",
        uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "name"})) // jedan student ne moze imati skillove istog imena
public class Interest {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "name")
    private String name;

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
}
