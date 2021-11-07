package com.azeam.reddish.user;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

@CrossOrigin
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserService userService;

    @PostMapping("/register")
    public String registerUser(@RequestBody UserCreate user, HttpServletResponse response) {
        int code = userService.registerUser(user);
        switch (code) {
        case 1:
            response.setStatus(409);
            return "There is already a user with that username";
        case 0:
            return "User has been registered.";
        default:
            response.setStatus(500);
            return "Something went wrong.";
        }
    }

    @PostMapping("/login")
    public String login(@RequestBody UserLogin user, HttpServletResponse response) {
        String token = userService.login(user);
        if (token == null) {
            response.setStatus(406);
            return null;
        }

        return token;
    }

    @PostMapping("/logout")
    public void login(@RequestHeader("token") String token) {
        userService.logout(token);
    }

    @Getter
    @Setter
    public static final class UserCreate {
        private String username;
        private String password;
    }

    @Getter
    @Setter
    public static final class UserLogin {
        private String username;
        private String password;
    }

}
