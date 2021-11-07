import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'helpers/token_helper.dart';
import 'podos/user.dart';
import 'posts.dart';
import 'register.dart';
import 'variables/strings.dart';
import 'widgets/snackbar.dart';
import 'widgets/user_form.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  User user = User(username: "", password: "");
  Uri url = Uri.parse(baseUrl + "/user/login");

  Future save() async {
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(user.toJson()));

    if (response.statusCode == 200) {
      await saveToken(response.body.toString());
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
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child:
                  userForm(context, "login", save, user, formKey, Register())),
        ));
  }
}
