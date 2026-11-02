package com.praksa.service;

import com.praksa.dto.InternshipDiaryDTO;
import java.net.http.HttpRequest;

public class DiaryService extends BaseService {

    private static final String ENDPOINT = "/api/diaries";

    public InternshipDiaryDTO getByStudentAndInternship(String studentId, String internshipId, String token) {
        HttpRequest request = get(ENDPOINT + "/student/" + studentId + "/internship/" + internshipId, token);
        return send(request, InternshipDiaryDTO.class);
    }
}