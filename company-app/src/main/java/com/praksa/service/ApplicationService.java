package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.ApplicationDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class ApplicationService extends BaseService {

    private static final String ENDPOINT = "/api/applications";

    public List<ApplicationDTO> getByInternship(String internshipId, String token) {
        HttpRequest request = get(ENDPOINT + "/internship/" + internshipId, token);
        return send(request, new TypeReference<List<ApplicationDTO>>() {});
    }

    public void accept(String applicationId, String token) {
        HttpRequest request = patch(
            ENDPOINT + "/" + applicationId + "/status?status=ACCEPTED", token);
        send(request);
    }

    public void reject(String applicationId, String token) {
        HttpRequest request = patch(
            ENDPOINT + "/" + applicationId + "/status?status=REJECTED", token);
        send(request);
    }
}