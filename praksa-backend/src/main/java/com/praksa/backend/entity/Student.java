package com.praksa.backend.entity;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "students")
public class Student {

    @Id
    @Column(length = 36)
    private String id;

    @OneToOne(cascade = CascadeType.ALL)
    @MapsId
    @JoinColumn(name = "id")
    private User user;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    private String phone;

    private String address;

    private String summary;

    @Column(name = "europass_json", columnDefinition = "json")
    private String europassJson;

    @Column(name = "photo_path")
    private String photoPath;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Skill> skills;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Interest> interests;

    // getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getEuropassJson() {
        return europassJson;
    }

    public void setEuropassJson(String europassJson) {
        this.europassJson = europassJson;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public void setInterests(List<Interest> interests) {
        this.interests = interests;
    }

    public List<Interest> getInterests() {
        return interests;
    }

    public void setSkills(List<Skill> skills) {
        this.skills = skills;
    }


    public List<Skill> getSkills() {
        return skills;
    }
}