package com.azeam.reddish.post;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PostService {

    @Autowired
    PostRepository postRepository;

    public Post createPost(Post post) {
        return postRepository.save(post);
    }

    public Post getPost(String id) {
        return postRepository.findById(id).orElse(null);
    }

    public List<Post> getPosts() {
        return postRepository.findAll();
    }

    public int like(Like like, String userId) {
        Post post = postRepository.findById(like.getId()).orElse(null);
        if (post == null)
            return 1;
        if (like.getLikes()) {
            post.setUpvotes(post.getUpvotes() + 1);
        } else {
            post.setDownvotes(post.getDownvotes() + 1);
        }
        post.getHasVoted().add(userId);
        postRepository.save(post);
        return 0;
    }

    public Post deletePost(String postId) {
        postRepository.deleteById(postId);
        return postRepository.findById(postId).orElse(null);
    }
}
