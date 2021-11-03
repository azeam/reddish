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
  int _selectedList = 0;

  Uri urlAll = Uri.parse(baseUrl + "/post/all");
  Uri urlFavorites = Uri.parse(baseUrl + "/post/favorites");
  Uri urlAddFavorite = Uri.parse(baseUrl + "/post/add-favorite");

  Future<List<Post>> fetchPost() async {
    final response = await http.get(_selectedList == 0 ? urlAll : urlFavorites,
        headers: {"token": await getToken()});
    if (response.statusCode == 200) {
      var postList = json.decode(response.body) as List;
      List<Post> posts = postList.map((i) => Post.fromJson(i)).toList();
      return posts;
    } else {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Posts(),
          ));
    }
    throw Exception("Failed to load posts");
  }

  Future addFavorite(String name) async {
    var response = await http.put(urlAddFavorite,
        headers: {"token": await getToken()}, body: name);
    if (response.statusCode == 200) {
      snackbar(context, "Post added to favorites");
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  void _onMenuChanged(int index) {
    setState(() {
      _selectedList = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedList == 0 ? "Post list" : "Favorites list"),
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
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return ListTile(
                      title: Text(post.name),
                      trailing: IconButton(
                        icon: _selectedList == 0
                            ? Icon(Icons.add_box)
                            : Icon(Icons.favorite),
                        onPressed: () {
                          if (_selectedList == 0) addFavorite(post.name);
                        },
                      ));
                });
          }),
      floatingActionButton: _selectedList == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => NewPost()));
              },
              icon: const Icon(Icons.library_add, color: CustomColors.bright),
              backgroundColor: CustomColors.dark,
              label:
                  Text("ADD POST", style: Theme.of(context).textTheme.button),
              shape: StadiumBorder(
                  side: BorderSide(color: CustomColors.bright, width: 1)))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedList,
        selectedItemColor: CustomColors.orange,
        backgroundColor: CustomColors.dark,
        onTap: _onMenuChanged,
      ),
    );
  }
}