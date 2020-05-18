import 'modify_studentlist_rest_ds.dart';

abstract class ModifyStudentListFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class ModifyStudentListFragmentPresenter {
  ModifyStudentListFragmentContract _view;
  ModifyStudentListRestDataSource api = new ModifyStudentListRestDataSource();

  ModifyStudentListFragmentPresenter(this._view);

  doFetch(String username, String auth_token, String pk_table,
      String required_timestamp) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token, pk_table, required_timestamp)
        .then((dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
