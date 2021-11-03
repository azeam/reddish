import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'helpers/number_helper.dart';
import 'helpers/token_helper.dart';
import 'podos/post.dart';
import 'posts.dart';
import 'variables/colors.dart';
import 'variables/strings.dart';
import 'widgets/snackbar.dart';

class NewPost extends StatefulWidget {
  NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final formKey = GlobalKey<FormState>();
  Post post = Post(name: "", description: "", price: 0);
  Uri url = Uri.parse(baseUrl + "/post/create");

  Future save() async {
    var response = await http.put(url,
        headers: {
          "token": await getToken(),
          "content-type": "application/json"
        },
        body: json.encode(post.toJson()));

    if (response.statusCode == 200) {
      snackbar(context, response.body.toString());
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Posts(),
          ));
    } else {
      snackbar(context, "An error occurred: " + response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New post"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Center(
                          child: Text(
                            "NEW POST",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: TextEditingController(text: post.name),
                        onChanged: (val) {
                          post.name = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Post name is empty";
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Post name",
                            hintText: "Enter a post name"),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: post.description),
                            onChanged: (val) {
                              post.description = val;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is empty";
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Description",
                                hintText: "Enter post description"),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: post.price.toString()),
                            onChanged: (val) {
                              post.price = int.parse(val);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price is empty";
                              }
                              if (!isNumeric(value)) {
                                return "Not a valid price";
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Price",
                                hintText: "Enter post price"),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CustomColors.dark,
                          border: Border.all(
                              color: CustomColors.bright, width: 1.5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              save();
                            }
                          },
                          child: Text(
                            "SAVE",
                            style: TextStyle(color: CustomColors.bright),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Posts()));
                          },
                          child: Text("Back to post list"))
                    ],
                  ),
                ))));
  }
}
