package com.azeam.reddish.post;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.annotation.Id;

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
    private List<String> hasVoted;

    public Post(String title, String body, int upvotes, int downvotes) {
        this.title = title;
        this.body = body;
        this.upvotes = upvotes;
        this.downvotes = downvotes;
        this.hasVoted = new ArrayList<>();
    }
}
