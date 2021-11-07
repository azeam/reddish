import "dart:convert";

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

import 'helpers/token_helper.dart';
import 'new_post.dart';
import 'podos/post.dart';
import 'variables/colors.dart';
import 'variables/strings.dart';
import 'widgets/menu_drawer.dart';
import 'widgets/snackbar.dart';

class Posts extends StatefulWidget {
  Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Uri urlAll = Uri.parse(baseUrl + "/post/all");
  Uri urlLike = Uri.parse(baseUrl + "/post/like");
  Uri urlDelete = Uri.parse(baseUrl + "/post/delete");

  String _id = "";
  bool _likes = false;

  Future<List<Post>> fetchPost() async {
    final response =
        await http.get(urlAll, headers: {"token": await getToken()});

    if (response.statusCode == 200) {
      List postList = json.decode(response.body);
      List<Post> posts = postList.map((i) => Post.fromJson(i)).toList();

      return posts;
    }
    throw Exception("Failed to load posts");
  }

  Future like() async {
    var response = await http.put(urlLike,
        headers: {
          "token": await getToken(),
          "Content-Type": "application/json; charset=utf-8"
        },
        body: json.encode({"id": _id, "likes": _likes}));
    if (response.statusCode == 200) {
      snackbar(context, _likes ? "Post liked" : "Post disliked");
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  Future delete() async {
    var response = await http.delete(urlDelete,
        headers: {
          "token": await getToken(),
        },
        body: _id);
    if (response.statusCode == 200) {
      snackbar(context, response.body.toString());
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  void _likePost(post) {
    setState(() {
      _likes = true;
      _id = post.id;
    });
    like();
  }

  void _dislikePost(post) {
    setState(() {
      _likes = false;
      _id = post.id;
    });
    like();
  }

  void _deletePost(post) {
    setState(() {
      _id = post.id;
    });
    delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post list"),
      ),
      drawer: menuDrawer(context),
      body: FutureBuilder<List<Post>>(
          future: fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              snackbar(context, "Error: " + snapshot.error.toString());
            }
            List<Post> posts = snapshot.data ?? [];
            return ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return Card(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                    title: Text(post.title),
                                    subtitle: Text(post.author),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.thumb_up),
                                          onPressed: () {
                                            _likePost(post);
                                          },
                                        ),
                                        Text(post.upvotes.toString()),
                                        IconButton(
                                          icon: Icon(Icons.thumb_down),
                                          onPressed: () {
                                            _dislikePost(post);
                                          },
                                        ),
                                        Text(post.downvotes.toString()),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _deletePost(post);
                                          },
                                        ),
                                      ],
                                    )),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Text(post.body)
                              ])));
                });
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => NewPost()));
          },
          icon: const Icon(Icons.library_add, color: CustomColors.bright),
          backgroundColor: CustomColors.dark,
          label: Text("ADD POST", style: Theme.of(context).textTheme.button),
          shape: StadiumBorder(
              side: BorderSide(color: CustomColors.bright, width: 1))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
