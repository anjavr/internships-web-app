package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.InternshipDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class InternshipService extends BaseService {

    private static final String ENDPOINT = "/api/internships";

    public List<InternshipDTO> getByCompany(String companyId, String token) {
        HttpRequest request = get(ENDPOINT + "/company/" + companyId, token);
        return send(request, new TypeReference<List<InternshipDTO>>() {});
    }

    public InternshipDTO getById(String id, String token) {
        HttpRequest request = get(ENDPOINT + "/" + id, token);
        return send(request, InternshipDTO.class);
    }

    public void create(InternshipDTO internship, String token) {
        System.out.println("CREATE TOKEN: " + token);
        HttpRequest request = post(ENDPOINT, internship, token);
        send(request);
    }

    public void update(String id, InternshipDTO internship, String token) {
        HttpRequest request = put(ENDPOINT + "/" + id, internship, token);
        send(request);
    }

    public void deleteInternship(String id, String token) {
        HttpRequest request = delete(ENDPOINT + "/" + id, token);
        send(request);
    }
}