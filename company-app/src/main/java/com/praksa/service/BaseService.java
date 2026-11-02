package com.praksa.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class BaseService {

    protected static final String BASE_URL = "http://localhost:8080";
    protected final HttpClient httpClient = HttpClient.newHttpClient();
    protected final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new com.fasterxml.jackson.datatype.jsr310.JavaTimeModule())
            .configure(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

    protected HttpRequest get(String endpoint, String token) {
        System.out.println("COMPANY TOKEN: " + token);
        System.out.println("ENDPOINT: " + endpoint);
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .GET()
                .build();
    }

    protected HttpRequest post(String endpoint, Object body, String token) {
        try {
            String json = objectMapper.writeValueAsString(body);
            return HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + endpoint))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + token)
                    .POST(HttpRequest.BodyPublishers.ofString(json))
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected HttpRequest post(String endpoint, Object body) {
        try {
            String json = objectMapper.writeValueAsString(body);
            return HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + endpoint))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(json))
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected HttpRequest put(String endpoint, Object body, String token) {
        try {
            String json = objectMapper.writeValueAsString(body);
            return HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + endpoint))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + token)
                    .PUT(HttpRequest.BodyPublishers.ofString(json))
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected HttpRequest delete(String endpoint, String token) {
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .DELETE()
                .build();
    }

    protected HttpRequest patch(String endpoint, String token) {
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .method("PATCH", HttpRequest.BodyPublishers.noBody())
                .build();
    }

    protected <T> T send(HttpRequest request, Class<T> responseType) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 401 || response.statusCode() == 403) {
                throw new RuntimeException("Unauthorized");
            }
            return objectMapper.readValue(response.body(), responseType);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected <T> T send(HttpRequest request, TypeReference<T> typeReference) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("RESPONSE STATUS: " + response.statusCode());
            System.out.println("RESPONSE BODY: " + response.body());
            if (response.statusCode() == 401 || response.statusCode() == 403) {
                throw new RuntimeException("Unauthorized");
            }
            return objectMapper.readValue(response.body(), typeReference);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected void send(HttpRequest request) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println("SEND STATUS: " + response.statusCode());
            System.out.println("SEND BODY: " + response.body());
            if (response.statusCode() == 401 || response.statusCode() == 403) {
                throw new RuntimeException("Unauthorized");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    protected HttpRequest patch(String endpoint, Object body, String token) {
        try {
            String json = objectMapper.writeValueAsString(body);
            return HttpRequest.newBuilder()
                    .uri(URI.create(BASE_URL + endpoint))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + token)
                    .method("PATCH", HttpRequest.BodyPublishers.ofString(json))
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}