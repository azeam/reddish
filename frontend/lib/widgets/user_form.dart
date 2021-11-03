import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddish/podos/user.dart';
import 'package:reddish/variables/colors.dart';

import 'snackbar.dart';

Widget userForm(
  BuildContext context,
  String type,
  Future Function() save,
  User user,
  GlobalKey<FormState> formKey,
  StatefulWidget otherPage,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Text(
              type == "register" ? "REGISTER" : "LOGIN",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
        TextFormField(
          controller: TextEditingController(text: user.username),
          onChanged: (val) {
            user.username = val;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Username is empty";
            }
            return null;
          },
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Username",
              hintText: "Enter a username"),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextFormField(
              obscureText: true,
              controller: TextEditingController(text: user.password),
              onChanged: (val) {
                user.password = val;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Password is empty";
                }
                return null;
              },
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "Enter secure password"),
            )),
        type == "login"
            ? TextButton(
                onPressed: () {
                  snackbar(context,
                      "Too bad, you should have used a password manager!");
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 15),
                ),
              )
            : SizedBox(
                height: 50,
              ),
        InkWell(
            child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.dark,
            border: Border.all(
                color: CustomColors.bright,
                width: 1.5,
                style: BorderStyle.solid),
          ),
          child: TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                save();
              }
            },
            child: Text(
              type == "register" ? "REGISTER" : "LOGIN",
              style: TextStyle(color: CustomColors.bright),
            ),
          ),
        )),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => otherPage));
            },
            child: Text(type == "register"
                ? "I already have an account"
                : "Register account"))
      ],
    ),
  );
}
