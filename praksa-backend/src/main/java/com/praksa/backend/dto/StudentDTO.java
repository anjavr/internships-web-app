package com.praksa.backend.dto;

import java.util.List;
public class StudentDTO {

    private String id;
    private String fullName;
    private String phone;
    private String address;
    private String summary;
    private String europassJson;
    private String photoPath;

    private String username;
    private String email;
    private String password;

    private List<SkillDTO> skills;
    private List<InterestDTO> interests;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhone() {
        return phone;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress() {
        return address;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getSummary() {
        return summary;
    }

    public void setEuropassJson(String europassJson) {
        this.europassJson = europassJson;
    }

    public String getEuropassJson() {
        return europassJson;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public void setInterests(List<InterestDTO> interests) {
        this.interests = interests;
    }

    public List<InterestDTO> getInterests() {
        return interests;
    }

    public void setSkills(List<SkillDTO> skills) {
        this.skills = skills;
    }

    public List<SkillDTO> getSkills() {
        return skills;
    }
}
