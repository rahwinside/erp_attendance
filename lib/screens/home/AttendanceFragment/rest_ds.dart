import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/get-attendance-details.php";

  Future<Map> fetch(String username, String auth_token) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
    }).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);
      if (res == "invalid-password")
        throw new Exception("Please check your credentials.");
      else if (res == "auth-error")
        throw new Exception(
            "Server is under maintenance, please try again later.");
//        return null;
      return res;
    });
  }
}
