package com.azeam.reddish.post;

import java.math.BigInteger;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.azeam.reddish.user.User;
import com.azeam.reddish.user.UserService;

import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
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

    @GetMapping("/favorites")
    public List<Post> getFavorites(@RequestHeader("token") String token, HttpServletResponse response) {
        User user = userService.validate(token);
        if (user == null) {
            response.setStatus(401);
            return null;
        }

        return user.getFavorites();
    }

    @PutMapping("/add-favorite")
    public String getFavorites(@RequestHeader("token") String token, @RequestBody String postName,
            HttpServletResponse response) {
        User user = userService.validate(token);
        if (user == null) {
            response.setStatus(401);
            return null;
        }
        System.out.println(postName);
        int result = postService.addFavorite(user, postName);
        switch (result) {
        case 1:
            response.setStatus(404);
            return "There is no post with that name";
        case 0:
            return "Post has been added to user's favorites";
        default:
            response.setStatus(500);
            return "Something went wrong.";
        }
    }

    @PostMapping("/create")
    public String createPost(@RequestHeader("token") String token, @RequestBody Post post,
            HttpServletResponse response) {
        if (userService.validate(token) == null) {
            response.setStatus(401);
            return null;
        }
        System.out.println(post.get_userId());
        User foundUser = userService.getUserById(post.get_userId());

        post.setAuthor(foundUser == null ? "Unknown user" : foundUser.getName());

        Post createdPost = postService.createPost(post);

        if (createdPost != null) {
            response.setStatus(200);
            return "Post " + createdPost.get_id().toString() + " has been created";
        }
        response.setStatus(500);
        return "Something went wrong.";
    }
}
