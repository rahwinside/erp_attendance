import 'superuser_rest_ds.dart';

abstract class SuperUserFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class SuperUserFragmentPresenter {
  SuperUserFragmentContract _view;
  SuperUserSelectionRestDataSource api = new SuperUserSelectionRestDataSource();

  SuperUserFragmentPresenter(this._view);

  doFetch(String username, String auth_token, String department, String year,
      String date, String hour) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token, department, year, date, hour).then((
        dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
