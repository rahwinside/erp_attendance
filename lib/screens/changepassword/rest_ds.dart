import 'dart:async';

import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/utils/network_util.dart';

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/reset-password.php";

  Future<User> login(String username, String password, String newPassword) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password,
      "newPassword": newPassword,
    }).then((dynamic res) async {
      res["username"] = username;
      print(res.toString());
      print(res.runtimeType);
      if (res == "invalid-password")
        throw new Exception("Failed to update your password.");
      else if (res == "auth-error")
        throw new Exception(
            "Server is under maintenance, please try again later.");
//        return null;
      var db = new DatabaseHelper();
      await db.deleteUsers();
      return new User.map(res);
    });
  }
}
