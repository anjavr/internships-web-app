package com.praksa.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class InternshipDiaryDTO {
    private String id;
    private String studentId;
    private String studentName;
    private String internshipId;
    private String internshipTitle;
    private String status;

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
    
    public String getStudentName() { 
    	return studentName; 
    }
    
    public void setStudentName(String studentName) { 
    	this.studentName = studentName;
    }
    
    public String getInternshipId() { 
    	return internshipId; 
    }
    
    public void setInternshipId(String internshipId) { 
    	this.internshipId = internshipId;
    }
    
    public String getInternshipTitle() {
    	return internshipTitle; 
    }
    
    public void setInternshipTitle(String internshipTitle) { 
    	this.internshipTitle = internshipTitle;
    }
    
    public String getStatus() {
    	return status;
    }
    
    public void setStatus(String status) { 
    	this.status = status;
    }
}