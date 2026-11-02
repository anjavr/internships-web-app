package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.praksa.dto.ApplicationDTO;
import com.praksa.dto.EvaluationDTO;
import java.net.http.HttpRequest;
import java.util.List;

public class EvaluationService extends BaseService {

    private static final String EVAL_ENDPOINT = "/api/evaluations";
    private static final String APP_ENDPOINT = "/api/applications";

    public List<ApplicationDTO> getAccepted(String token) {
        HttpRequest request = get(APP_ENDPOINT + "/accepted", token);
        return send(request, new TypeReference<List<ApplicationDTO>>() {});
    }

    public EvaluationDTO getEvaluation(String studentId, 
            String internshipId, String token) {
        HttpRequest request = get(EVAL_ENDPOINT + "/student/" + 
                studentId + "/internship/" + internshipId, token);
        return send(request, EvaluationDTO.class);
    }

    public EvaluationDTO save(EvaluationDTO dto, String token) {
        HttpRequest request = post(EVAL_ENDPOINT, dto, token);
        return send(request, EvaluationDTO.class);
    }
}