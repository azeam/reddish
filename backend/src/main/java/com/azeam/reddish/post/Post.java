package com.azeam.reddish.post;

import java.math.BigInteger;

import com.azeam.reddish.user.User;
import com.azeam.reddish.user.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.annotation.Id;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Post {
    @Id
    private String _id;
    private String _userId;
    private String title, body;
    private int upvotes, downvotes;
    private String author;

    public Post(String _userId, String title, String body, int upvotes, int downvotes) {
        this.title = title;
        this.body = body;
        this._userId = _userId;
        this.upvotes = upvotes;
        this.downvotes = downvotes;
    }
}
