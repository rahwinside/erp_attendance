import 'onduty_rest_ds.dart';

abstract class OnDutyFragmentContract {
  void onFetchSuccess(dynamic res);

  void onFetchError(String errorTxt);
}

class OnDutyFragmentPresenter {
  OnDutyFragmentContract _view;
  OnDutySelectionRestDataSource api = new OnDutySelectionRestDataSource();

  OnDutyFragmentPresenter(this._view);

  doFetch(String username, String auth_token, String department, String year,
      String date, String hour) {
    print(username + " " + auth_token);
    api.fetch(username, auth_token, department, year, date, hour).then((
        dynamic res) {
      _view.onFetchSuccess(res);
    }).catchError((Object error) => _view.onFetchError(error.toString()));
  }
}
