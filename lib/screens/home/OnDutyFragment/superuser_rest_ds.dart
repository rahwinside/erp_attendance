import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class SuperUserSelectionRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final LOGIN_URL = BASE_URL + "/od-superuser.php";

  Future<dynamic> fetch(String username, String auth_token, String department,
      String year, String date, String hour) {
    print(username + auth_token + department + year + date + hour);
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "auth_token": auth_token,
      "department": department,
      "year": year,
      "date": date,
      "hour": hour,
    }).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);
      if (res == "no-class")
        throw new Exception(
            "No class was scheduled for this hour.");
      else if (res == "invalid-auth-or-access")
        throw new Exception(
            "You do not have the privileges to access this content.");
      else if (res == "not-taken")
        throw new Exception(
            "Will be removed in next revision.");
//        return null;
      return res;
    });
  }
}
