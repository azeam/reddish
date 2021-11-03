package com.azeam.reddish.post;

import java.util.List;

import com.azeam.reddish.user.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostService {

    @Autowired
    PostRepository postRepository;

    public int createPost(Post post) {
        Post existing = postRepository.findByName(post.getName());
        if (existing != null)
            return 1;

        postRepository.save(post);

        return 0;
    }

    public List<Post> getPosts() {
        return postRepository.findAll();
    }

    public int addFavorite(User user, String postName) {
        Post post = postRepository.findByName(postName);
        if (post == null)
            return 1;

        user.getFavorites().add(post);
        return 0;
    }
}
