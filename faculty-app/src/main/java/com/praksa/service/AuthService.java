package com.praksa.service;

import com.praksa.dto.LoginRequestDTO;
import com.praksa.dto.LoginResponseDTO;
import java.net.http.HttpRequest;

public class AuthService extends BaseService {

	private static final String ENDPOINT = "/api/auth/login";

	public LoginResponseDTO login(String username, String password) {
		try {
			System.out.println("AUTH SERVICE LOGIN CALLED");
			LoginRequestDTO requestDto = new LoginRequestDTO(username, password, "FACULTY");
			HttpRequest request = post(ENDPOINT, requestDto);
			System.out.println("SENDING REQUEST TO: " + BASE_URL + ENDPOINT);
			java.net.http.HttpResponse<String> response = httpClient.send(request,
					java.net.http.HttpResponse.BodyHandlers.ofString());
			System.out.println("STATUS: " + response.statusCode());
			System.out.println("BODY: " + response.body());
			LoginResponseDTO resp = objectMapper.readValue(response.body(), LoginResponseDTO.class);
			System.out.println("RESPONSE TOKEN: " + resp.getToken());
			return resp;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
}