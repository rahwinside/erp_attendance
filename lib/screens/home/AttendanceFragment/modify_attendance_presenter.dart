import 'modify_rest_ds.dart';

abstract class ModifyAttendanceFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class ModifyAttendanceFragmentPresenter {
  ModifyAttendanceFragmentContract _view;
  ModifyAttRestDataSource api = new ModifyAttRestDataSource();

  ModifyAttendanceFragmentPresenter(this._view);

  doFetch(String username, String auth_token, String hour) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token, hour).then((dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
