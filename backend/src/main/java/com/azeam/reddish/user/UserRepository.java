package com.azeam.reddish.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    final Map<String, User> users = new HashMap<>();

    public User findByName(String firstName);
}
