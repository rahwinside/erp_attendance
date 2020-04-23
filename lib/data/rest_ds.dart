import 'dart:async';

import 'package:attendance/models/user.dart';
import 'package:attendance/utils/network_util.dart';

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/login.php";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password,
      "userType": "admin",
    }).then((dynamic res) {
      res["username"] = username;
      print(res.toString());
      print(res.runtimeType);
      if (res == "invalid-password")
        throw new Exception("Please check your credentials.");
      else if (res == "auth-error")
        throw new Exception(
            "Server is under maintenance, please try again later.");

//        return null;
      return new User.map(res);
    });
  }
}
