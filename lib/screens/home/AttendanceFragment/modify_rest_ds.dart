import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class ModifyAttRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://10.0.2.2:80";
  static final LOGIN_URL = BASE_URL + "/test.php";

  Future<dynamic> fetch(String username, String auth_token, String hour) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "hour": hour,
    }).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);
      if (res == "no-class")
        throw new Exception(
            "You do not have any class scheduled for this hour");
      else if (res == "invalid-auth-or-access")
        throw new Exception(
            "You do not have the privileges to access this content");
//        return null;
      return res;
    });
  }
}
