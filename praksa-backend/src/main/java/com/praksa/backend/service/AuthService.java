package com.praksa.backend.service;

import com.praksa.backend.dto.request.LoginRequest;
import com.praksa.backend.dto.response.LoginResponse;
import com.praksa.backend.entity.User;
import com.praksa.backend.repository.UserRepository;
import com.praksa.backend.util.JwtUtil;
import lombok.AllArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class AuthService {

    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest loginRequest) {
        System.out.println("LOGIN ATTEMPT: " + loginRequest.username() + " / role: " + loginRequest.role());

        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.username(),
                            loginRequest.password()));
            System.out.println("AUTH SUCCESS");

            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            String requestedRole = "ROLE_" + loginRequest.role();
            boolean hasRole = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals(requestedRole));
            System.out.println("Requested role: " + requestedRole);
            System.out.println("Has role: " + hasRole);
            System.out.println("Authorities: " + authentication.getAuthorities());

            if (!hasRole) {
                throw new AccessDeniedException("Nemate pristup ovoj aplikaciji");
            }

            User user = userRepository.findByUsername(loginRequest.username())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            return new LoginResponse(jwtUtil.generateToken(userDetails), user.getId());

        } catch (Exception e) {
            System.out.println("AUTH FAILED: " + e.getClass().getName() + " - " + e.getMessage());
            throw e;
        }
    }

    public void changePassword(String userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new RuntimeException("Invalid old password");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}