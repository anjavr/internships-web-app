package com.praksa.dto;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EuropassJson {
	
    private List<EducationDTO> education;
    private List<ExperienceDTO> experience;
    
    public List<EducationDTO> getEducation() { 
    	return education; 
    }
    
    public void setEducation(List<EducationDTO> education) { 
    	this.education = education;
    }
    
    public List<ExperienceDTO> getExperience() { 
    	return experience;
    }
    
    public void setExperience(List<ExperienceDTO> experience) {
    	this.experience = experience;
    }
}