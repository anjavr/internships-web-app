package com.praksa.backend.controller;

import com.praksa.backend.dto.request.LoginRequest;
import com.praksa.backend.dto.response.LoginResponse;
import com.praksa.backend.entity.User;
import com.praksa.backend.service.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.praksa.backend.util.JwtUtil;
import com.praksa.backend.repository.UserRepository;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        try {
            return ResponseEntity.ok(authService.login(request));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("LOGIN ERROR: " + e.getMessage());
            return ResponseEntity.status(401).build();
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<Void> changePassword(
            @RequestBody Map<String, String> body,
            @RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.substring(7);
            String username = jwtUtil.extractUsername(token);
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            authService.changePassword(
                    user.getId(),
                    body.get("oldPassword"),
                    body.get("newPassword"));
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(400).build();
        }
    }
}