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
    }).then((dynamic resToken) {
      print(resToken.toString());
      print(resToken.runtimeType);
      if (resToken == "invalid-password")
        throw new Exception("Please check your credentials.");
      else if (resToken == "auth-error")
        throw new Exception(
            "Server is under maintenance, please try again later.");

      var identity = {"username": username, "authToken": resToken};

      return new User.map(identity);
    });
  }
}
