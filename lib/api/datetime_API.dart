import 'dart:async';

import 'package:attendance/utils/network_util.dart';

class DateTimeRestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://weareeverywhere.in";
  static final API_URL = BASE_URL + "/get-current-datetime-day.php";

  Future<dynamic> getServerClock() {
    return _netUtil.post(API_URL).then((dynamic res) {
      print(res.toString());
      print(res.runtimeType);
      return res;
    });
  }
}