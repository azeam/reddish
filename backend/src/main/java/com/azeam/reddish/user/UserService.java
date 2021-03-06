package com.azeam.reddish.user;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    public String login(UserController.UserLogin user) {
        User foundUser = userRepository.findByName(user.getUsername());
        if (foundUser == null)
            return null;

        if (!foundUser.getPassword().equals(user.getPassword()))
            return null;

        String token = UUID.randomUUID().toString();
        tokens.put(token, foundUser);

        return token;
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
