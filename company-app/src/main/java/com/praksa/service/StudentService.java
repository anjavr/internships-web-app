package com.praksa.service;

import com.praksa.dto.StudentDTO;
import java.net.http.HttpRequest;

public class StudentService extends BaseService {

    private static final String ENDPOINT = "/api/students";

    public StudentDTO getById(String id, String token) {
        HttpRequest request = get(ENDPOINT + "/" + id, token);
        return send(request, StudentDTO.class);
    }
}