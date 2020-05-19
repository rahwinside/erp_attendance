import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class UploadAttendanceRest {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/take-attendance.php";

  Future<dynamic> upload(String username, String auth_token, String pk_table,
      String datetime_column, String response) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "subCode_dept_sem": pk_table,
      "datetime_column": datetime_column,
      "attendance_list": response,
    }).then((dynamic res) {
      print(res.toString());
      return res;
    });
  }
}
