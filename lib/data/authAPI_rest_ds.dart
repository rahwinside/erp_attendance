import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class AuthRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/auth-status.php";

  Future<bool> auth(String username, String auth_token) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
    }).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);

//      bool resBool = false;
//      switch(res){
//        case "true":
//          resBool = true;
//          break;
//        case "false":
//          resBool = false;
//          break;
//      }

      if (res == "true")
        return true;
      else if (res == "false") {
        return false;
      } else
        throw new Exception(
            "Server is under maintenance, please try again later.");
    });
  }
}
