package com.praksa.backend.mapper;

import com.praksa.backend.dto.UserDTO;
import com.praksa.backend.entity.User;

public class UserMapper {

    public static UserDTO toDTO(User user){
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setPasswordHash(user.getPasswordHash());
        dto.setRole(user.getRole());
        dto.setActive(user.isActive());
        return dto;
    }

    public static User toEntity(UserDTO dto){
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPasswordHash());
        user.setRole(dto.getRole());
        user.setActive(dto.isActive());
        return user;
    }
}
