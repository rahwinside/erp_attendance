import 'package:attendance/screens/home/AttendanceFragment/rest_ds.dart';

abstract class AttendanceFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class AttendanceFragmentPresenter {
  AttendanceFragmentContract _view;
  RestDataSource api = new RestDataSource();

  AttendanceFragmentPresenter(this._view);

  doFetch(String username, String auth_token) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token).then((dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
