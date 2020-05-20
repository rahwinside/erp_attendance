import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class ModifyUploadAttendanceRest {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL =
      BASE_URL + "/update-attendance-modify-attendance.php";

  Future<dynamic> upload(String username, String auth_token, String pk_table,
      String required_timestamp, String status_json) {
    print(status_json);
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "subCode_dept_sem": pk_table,
      "required_timestamp": required_timestamp,
      "status_json": status_json,
    }).then((dynamic res) {
      return res;
    });
  }
}
