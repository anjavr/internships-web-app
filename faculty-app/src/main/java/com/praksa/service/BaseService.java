package com.praksa.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.fasterxml.jackson.core.type.TypeReference;

public class BaseService {

	protected static final String BASE_URL = "http://localhost:8080";
    
	protected final HttpClient httpClient = HttpClient.newBuilder()
	        .version(HttpClient.Version.HTTP_1_1)
	        .connectTimeout(java.time.Duration.ofSeconds(10))
	        .build();
    protected final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new com.fasterxml.jackson.datatype.jsr310.JavaTimeModule())
            .configure(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    
    // samo za login
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
    
    protected HttpRequest get(String endpoint, String token) {
    	System.out.println("TOKEN: " + token);
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .GET()
                .build();
    }
    
    
    protected <T> T send(HttpRequest request, Class<T> responseType) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 401) {
                throw new RuntimeException("Unauthorized");
            }
            
            return objectMapper.readValue(response.body(), responseType);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    protected void send(HttpRequest request) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("STATUS = " + response.statusCode());
            System.out.println("BODY = " + response.body());
            
            if (response.statusCode() == 401) {
                throw new RuntimeException("Unauthorized");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    protected <T> T send(HttpRequest request, TypeReference<T> typeReference) {
        try {
            HttpResponse<String> response = httpClient
                    .send(request, HttpResponse.BodyHandlers.ofString());

            System.out.println("STATUS: " + response.statusCode());
            System.out.println("BODY: " + response.body());

            if (response.statusCode() == 401 || response.statusCode() == 403) {
                throw new RuntimeException("Unauthorized");
            }

            return objectMapper.readValue(response.body(), typeReference);
        } catch (Exception e) {
            e.printStackTrace(); // OVO JE KLJUCNO
            System.out.println("SEND ERROR: " + e.getClass().getName() + " - " + e.getMessage());
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

    protected HttpRequest patch(String endpoint, String token) {
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .method("PATCH", HttpRequest.BodyPublishers.noBody())
                .build();
    }
    
    protected HttpRequest delete(String endpoint, String token) {
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .DELETE()
                .build();
    }
    
    // za slanje csv fajla
    protected HttpRequest postMultipart(String endpoint, byte[] fileBytes, 
            String fileName, String token) {
        String boundary = "----Boundary" + System.currentTimeMillis();
        
        String header = "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"file\"; filename=\"" + 
                fileName + "\"\r\n" +
                "Content-Type: text/csv\r\n\r\n";
        String footer = "\r\n--" + boundary + "--\r\n";
        
        byte[] headerBytes = header.getBytes();
        byte[] footerBytes = footer.getBytes();
        byte[] body = new byte[headerBytes.length + fileBytes.length + footerBytes.length];
        System.arraycopy(headerBytes, 0, body, 0, headerBytes.length);
        System.arraycopy(fileBytes, 0, body, headerBytes.length, fileBytes.length);
        System.arraycopy(footerBytes, 0, body, 
                headerBytes.length + fileBytes.length, footerBytes.length);
        
        return HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + token)
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofByteArray(body))
                .build();
    }
}
