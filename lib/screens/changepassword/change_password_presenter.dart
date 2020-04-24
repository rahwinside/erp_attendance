import 'package:attendance/models/user.dart';
import 'package:attendance/screens/changepassword/rest_ds.dart';

abstract class ChangePasswordScreenContract {
  void onUpdateSuccess(User user);

  void onUpdateError(String errorTxt);
}

class ChangePasswordScreenPresenter {
  ChangePasswordScreenContract _view;
  RestDataSource api = new RestDataSource();

  ChangePasswordScreenPresenter(this._view);

  doUpdate(String username, String password, String newPassword) {
    api.login(username, password, newPassword).then((User user) {
      _view.onUpdateSuccess(user);
    }).catchError((Object error) => _view.onUpdateError(error.toString()));
  }
}
