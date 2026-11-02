package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.StudentDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class StudentService extends BaseService{

	private static final String ENDPOINT = "/api/students";

	public List<StudentDTO> getAll(String token) {
	    HttpRequest request = get(ENDPOINT, token);
	    return send(request, new TypeReference<List<StudentDTO>>() {});
	}

	public StudentDTO getById(String id, String token) {
	    HttpRequest request = get(ENDPOINT + "/" + id, token);
	    return send(request, StudentDTO.class);
	}

	public void create(StudentDTO student, String token) {
	    HttpRequest request = post(ENDPOINT, student, token);
	    send(request);
	}

	public StudentDTO update(String id, StudentDTO student, String token) {
	    HttpRequest request = put(ENDPOINT + "/" + id, student, token);
	    return send(request, StudentDTO.class);
	}
	
	public void setActive(String id, boolean active, String token) {
        HttpRequest request = patch(ENDPOINT + "/" + id + "/active?active=" + active, token);
        send(request);
    }
	
	public void deleteStudent(String id, String token) {
	    HttpRequest request = delete(ENDPOINT + "/" + id, token);
	    send(request);
	}
	
	public void uploadCsv(byte[] fileBytes, String token) {
	    HttpRequest request = postMultipart(
	            "/api/students/upload", fileBytes, "students.csv", token);
	    send(request);
	}
}
