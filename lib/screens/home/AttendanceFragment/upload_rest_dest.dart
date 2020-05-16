import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class UploadAttendanceRest {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/temp.php";

  Future<dynamic> upload(
      String username, String auth_token, String timestamp, String response) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "timestamp": timestamp,
      "response": response,
    }).then((dynamic res) {
      return res;
    });
  }
}
