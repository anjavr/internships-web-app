package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.WorkLogDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class WorkLogService extends BaseService {

    private static final String ENDPOINT = "/api/worklogs";

    public List<WorkLogDTO> getByInternship(String internshipId, String token) {
        HttpRequest request = get(ENDPOINT + "/internship/" + internshipId, token);
        return send(request, new TypeReference<List<WorkLogDTO>>() {});
    }

    public List<WorkLogDTO> getByStudent(String studentId, String token) {
        HttpRequest request = get(ENDPOINT + "/student/" + studentId, token);
        return send(request, new TypeReference<List<WorkLogDTO>>() {});
    }

    public void addFeedback(String workLogId, String feedback, String token) {
        java.util.Map<String, String> body = new java.util.HashMap<>();
        body.put("feedback", feedback);
        HttpRequest request = patch(ENDPOINT + "/" + workLogId + "/feedback", body, token);
        send(request);
    }
}