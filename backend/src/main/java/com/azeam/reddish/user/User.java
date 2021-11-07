package com.azeam.reddish.user;

import org.springframework.data.annotation.Id;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
    @Id
    private String _id;
    private String name, password;

    public User(String name, String password) {
        this.name = name;
        this.password = password;
    }
}
