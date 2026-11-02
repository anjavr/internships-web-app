package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.WorkLogDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class WorkLogService extends BaseService {

    private static final String ENDPOINT = "/api/worklogs";

    public List<WorkLogDTO> getByStudent(String studentId, String token) {
        HttpRequest request = get(ENDPOINT + "/student/" + studentId, token);
        return send(request, new TypeReference<List<WorkLogDTO>>() {});
    }
}