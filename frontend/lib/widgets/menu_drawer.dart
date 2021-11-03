import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login.dart';

Widget menuDrawer(context) {
  return Drawer(
      child: ListView(children: [
    ListTile(
      title: const Text("Log out"),
      trailing: const Icon(Icons.logout),
      onTap: () async {
        await deleteToken();
        Navigator.pop(context);
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Login(),
            ));
      },
    )
  ]));
}

deleteToken() {}
