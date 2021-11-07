package com.azeam.reddish.post;

import java.util.List;

import com.azeam.reddish.user.User;
import com.azeam.reddish.user.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostService {

    @Autowired
    PostRepository postRepository;

    public Post createPost(Post post) {
        return postRepository.save(post);
    }

    public List<Post> getPosts() {
        return postRepository.findAll();
    }

    public int addFavorite(User user, String title) {
        Post post = postRepository.findByTitle(title);
        if (post == null)
            return 1;

        user.getFavorites().add(post);
        return 0;
    }
}
