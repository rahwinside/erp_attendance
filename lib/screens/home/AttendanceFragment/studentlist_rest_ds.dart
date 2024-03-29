import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class StudentListRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/get-pk-list.php";

  Future<dynamic> fetch(String username, String auth_token, String pk_table,
      String required_timestamp) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "subCode_dept_sem": pk_table,
      "required_timestamp": required_timestamp,
    }).then((dynamic res) {
      return res;
    });
  }
}
