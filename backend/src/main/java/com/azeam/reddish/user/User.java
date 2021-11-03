package com.azeam.reddish.user;

import java.util.ArrayList;
import java.util.List;

import com.azeam.reddish.post.Post;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {

    private String name, password;
    private List<Post> favorites;

    public User(String name, String password) {
        this.name = name;
        this.password = password;
        this.favorites = new ArrayList<>();
    }
}
