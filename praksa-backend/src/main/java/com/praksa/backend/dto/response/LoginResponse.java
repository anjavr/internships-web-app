package com.praksa.backend.dto.response;

public class LoginResponse {
    private String token;
    private String userId;

    public LoginResponse(String token, String userId) {
        this.token = token;
        this.userId = userId;
    }

    public String getToken() { return token; }
    public String getUserId() { return userId; }
}