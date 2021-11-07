package com.azeam.reddish.post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends MongoRepository<Post, String> {
    Map<String, Post> posts = new HashMap<>();

    public Post findByTitle(String title);

    public List<Post> findAll();
}
