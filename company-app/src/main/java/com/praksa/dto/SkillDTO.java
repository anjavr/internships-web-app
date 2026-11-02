package com.praksa.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SkillDTO {
    private String name;
    private String level;

    public String getName() {
    	return name;
    }
    
    public void setName(String name) { 
    	this.name = name;
    }
    
    public String getLevel() {
    	return level;
    }
    
    public void setLevel(String level) { 
    	this.level = level;
    }
}