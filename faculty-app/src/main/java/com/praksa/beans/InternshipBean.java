package com.praksa.beans;

import com.praksa.dto.InternshipDTO;
import com.praksa.service.InternshipService;
import java.util.List;

public class InternshipBean {

	private List<InternshipDTO> internships;
	private InternshipDTO internship;
	
	private final InternshipService internshipService = new InternshipService();

	//getters and setters
	public List<InternshipDTO> getInternships() {
		return internships;
	}

	public void setInternships(List<InternshipDTO> internships) {
		this.internships = internships;
	}

	public InternshipDTO getInternship() {
		return internship;
	}

	public void setInternship(InternshipDTO internship) {
		this.internship = internship;
	}

	public InternshipService getInternshipService() {
		return internshipService;
	}
	
	
	public List<InternshipDTO> getAll(String token){
		this.internships = internshipService.getAll(token);
        return this.internships;
	}
	
	public List<InternshipDTO> getAllForFaculty(String token) {
	    this.internships = internshipService.getAllForFaculty(token);
	    return this.internships;
	}
	
	public InternshipDTO getById(String id, String token) {
        this.internship = internshipService.getById(id, token);
        return this.internship;
    }
	
}
