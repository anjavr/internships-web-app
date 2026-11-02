package com.praksa.service;

import com.praksa.dto.LoginRequestDTO;
import com.praksa.dto.LoginResponseDTO;
import java.net.http.HttpRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;

public class AuthService extends BaseService {

    private static final String ENDPOINT = "/api/auth/login";

    public String login(String username, String password) {
        LoginRequestDTO requestDto = new LoginRequestDTO(username, password, "COMPANY");
        HttpRequest request = post(ENDPOINT, requestDto);
        LoginResponseDTO response = send(request, LoginResponseDTO.class);
        return response.getToken();
    }
    
    public String extractCompanyId(String token) {
        try {
            String[] parts = token.split("\\.");
            String payload = new String(java.util.Base64.getDecoder().decode(parts[1]));
            
            ObjectMapper mapper = new ObjectMapper();
            TypeReference<Map<String, Object>> typeRef = new TypeReference<Map<String, Object>>() {};
            Map<String, Object> claims = mapper.readValue(payload, typeRef);
            
            return (String) claims.get("userId");
        } catch (Exception e) {
            throw new RuntimeException("Cannot extract companyId from token");
        }
    }
}