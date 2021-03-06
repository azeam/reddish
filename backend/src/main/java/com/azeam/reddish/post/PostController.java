package com.azeam.reddish.post;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.azeam.reddish.user.User;
import com.azeam.reddish.user.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin
@RestController
@RequestMapping("/post")
public class PostController {

    @Autowired
    PostService postService;

    @Autowired
    UserService userService;

    @GetMapping("/all")
    public List<Post> getPosts(@RequestHeader("token") String token, HttpServletResponse response) {
        if (userService.validate(token) == null) {
            response.setStatus(401);
            return null;
        }

        return postService.getPosts();
    }

    @PutMapping("/like")
    public String getLikes(@RequestHeader("token") String token, @RequestBody Like like, HttpServletResponse response) {
        User user = userService.validate(token);
        if (user == null) {
            response.setStatus(401);
            return null;
        }

        Post post = postService.getPost(like.getId());

        if (post == null) {
            response.setStatus(404);
            return "There is no post with that id";
        }
        if (post.get_userId().equals(user.get_id())) {
            response.setStatus(401);
            return "Can not like/dislike your own posts";
        }
        if (post.getHasVoted().contains(user.get_id())) {
            response.setStatus(401);
            return "Already voted";
        }
        postService.like(like, user.get_id());
        return "success";
    }

    @PostMapping("/create")
    public String createPost(@RequestHeader("token") String token, @RequestBody Post post,
            HttpServletResponse response) {
        User user = userService.validate(token);
        if (user == null) {
            response.setStatus(401);
            return null;
        }
        post.setAuthor(user.getName());
        post.set_userId(user.get_id());

        Post createdPost = postService.createPost(post);

        if (createdPost != null) {
            response.setStatus(200);
            return "Post " + createdPost.get_id().toString() + " has been created";
        }
        response.setStatus(500);
        return "Something went wrong.";
    }

    @DeleteMapping("/delete")
    public String deletePost(@RequestHeader("token") String token, @RequestBody String postId,
            HttpServletResponse response) {
        User user = userService.validate(token);
        if (user == null) {
            response.setStatus(401);
            return null;
        }
        Post post = postService.getPost(postId);

        if (!post.get_userId().equals(user.get_id())) {
            response.setStatus(401);
            return "Can not delete other users posts";
        }

        Post deletedPost = postService.deletePost(postId);

        if (deletedPost == null) {
            response.setStatus(200);
            return "Post has been deleted";
        }
        response.setStatus(500);
        return "Something went wrong.";
    }
}
