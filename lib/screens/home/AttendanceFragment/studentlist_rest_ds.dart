import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class StudentListRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/get-pk-list.php";

  Future<dynamic> fetch(String username, String auth_token, String pk_table) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "subCode_dept_sem": pk_table,
    }).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);
//      if (res == "no-class")
//        throw new Exception(
//            "You do not have any class scheduled for this hour");
//      else if (res == "invalid-auth-or-access")
//        throw new Exception(
//            "You do not have the privileges to access this content");
//        return null;
      return res;
    });
  }
}
