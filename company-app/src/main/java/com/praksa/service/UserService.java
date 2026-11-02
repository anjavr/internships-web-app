package com.praksa.service;

import java.net.http.HttpRequest;
import java.util.HashMap;
import java.util.Map;

public class UserService extends BaseService {

    private static final String ENDPOINT = "/api/auth/change-password";

    public void changePassword(String oldPassword, 
        String newPassword, String token) {
        Map<String, String> body = new HashMap<>();
        body.put("oldPassword", oldPassword);
        body.put("newPassword", newPassword);
        HttpRequest request = post(ENDPOINT, body, token);
        send(request);
    }
}