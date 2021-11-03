import 'package:shared_preferences/shared_preferences.dart';

saveToken(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', value);
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token")!;
  return token;
}

deleteToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("token");
}
