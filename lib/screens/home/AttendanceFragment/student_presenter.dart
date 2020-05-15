import 'package:attendance/screens/home/AttendanceFragment/studentlist_rest_ds.dart';

abstract class StudentListFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class StudentListFragmentPresenter {
  StudentListFragmentContract _view;
  StudentListRestDataSource api = new StudentListRestDataSource();

  StudentListFragmentPresenter(this._view);

  doFetch(String username, String auth_token, String pk_table) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token, pk_table).then((dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
