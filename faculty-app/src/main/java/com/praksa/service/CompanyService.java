package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.CompanyDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class CompanyService extends BaseService{

	private static final String ENDPOINT = "/api/companies";

	public List<CompanyDTO> getAll(String token) {
		HttpRequest request = get(ENDPOINT, token);
		return send(request, new TypeReference<List<CompanyDTO>>() {
		});
	}

	public CompanyDTO getById(String id, String token) {
		HttpRequest request = get(ENDPOINT + "/" + id, token);
		return send(request, CompanyDTO.class);
	}
	
	 public void create(CompanyDTO company, String token) {
	    HttpRequest request = post(ENDPOINT, company, token);
	    send(request);
	}
	 
	public CompanyDTO update(String id, CompanyDTO company, String token) {
	    HttpRequest request = put(ENDPOINT + "/" + id, company, token);
	    return send(request, CompanyDTO.class);
	}
	
	public void setActive(String id, boolean active, String token) {
        HttpRequest request = patch(ENDPOINT + "/" + id + "/active?active=" + active, token);
        send(request);
    }
}
