package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import java.net.http.HttpRequest;
import java.util.List;

import com.praksa.dto.InternshipDTO;

public class InternshipService extends BaseService{

	private static final String ENDPOINT = "/api/internships";
	
	public List<InternshipDTO> getAll(String token){
		HttpRequest request = get(ENDPOINT,token);
		return send(request, new TypeReference<List<InternshipDTO>>() {
		});
	}
	
	public List<InternshipDTO> getAllForFaculty(String token) {
	    HttpRequest request = get(ENDPOINT + "/all", token);
	    return send(request, new TypeReference<List<InternshipDTO>>() {});
	}
	
	 public InternshipDTO getById(String id, String token) {
	        HttpRequest request = get(ENDPOINT + "/" + id, token);
	        return send(request, InternshipDTO.class);
	    }
}
