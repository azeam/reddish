package com.azeam.reddish.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    public String login(String username, String password) {
        User user = userRepository.findByName(username);
        if (user == null)
            return null;

        if (!user.getPassword().equals(password))
            return null;

        String token = UUID.randomUUID().toString();
        tokens.put(token, user);
        return token;
    }

    public void logout(String token) {
        tokens.remove(token);
    }

    public User validate(String token) {
        return tokens.get(token);
    }
}
