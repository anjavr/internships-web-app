package com.praksa.backend.service;

import com.praksa.backend.dto.UserDTO;
import com.praksa.backend.entity.User;
import com.praksa.backend.mapper.UserMapper;
import com.praksa.backend.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    //read
    public List<UserDTO> findAll(){
        return userRepository.findAll().
                stream().map(UserMapper::toDTO).collect(Collectors.toList());
    }

    public UserDTO findById(String id){
        User user = userRepository.findById(id).
                orElseThrow(() -> new RuntimeException("User not found"));
        return UserMapper.toDTO(user);
    }

    //update
    @Transactional
    public UserDTO update(UserDTO userDTO, String id){
        User user = userRepository.findById(id).
                orElseThrow(() -> new RuntimeException("User not found"));
        user.setUsername(userDTO.getUsername());
        user.setEmail(userDTO.getEmail());
        user.setPasswordHash(userDTO.getPasswordHash());
        user.setRole(userDTO.getRole());
        return UserMapper.toDTO(userRepository.save(user));
    }

    //delete
    @Transactional
    public void delete(String id){
        userRepository.deleteById(id);
    }

    //activate/deactivate
    public UserDTO setActive(String id, boolean active) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setActive(active);
        return UserMapper.toDTO(userRepository.save(user));
    }
}
