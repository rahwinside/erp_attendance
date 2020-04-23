import 'package:attendance/data/rest_ds.dart';
import 'package:attendance/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    print(username);
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Object error) => _view.onLoginError(error.toString()));
  }
}
