package com.azeam.reddish.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.*;

@Service
public class UserService {

    @Autowired
    UserRepository userRepository;

    Map<String, User> tokens = new HashMap<>();

    public int registerUser(UserController.UserCreate user) {
        User existing = userRepository.findByName(user.getUsername());
        if (existing != null)
            return 1;

        userRepository.save(new User(user.getUsername(), user.getPassword()));

        return 0;
    }

    public HashMap<String, String> login(UserController.UserLogin user) {
        User foundUser = userRepository.findByName(user.getUsername());
        if (foundUser == null)
            return null;

        if (!foundUser.getPassword().equals(user.getPassword()))
            return null;

        String token = UUID.randomUUID().toString();
        tokens.put(token, foundUser);
        HashMap<String, String> response = new HashMap<>();
        response.put("token", token);
        response.put("_userId", foundUser.get_id());
        return response;
    }

    public void logout(String token) {
        tokens.remove(token);
    }

    public User validate(String token) {
        return tokens.get(token);
    }

    public User getUserById(String id) {
        return userRepository.findById(id).orElse(null);
    }
}
