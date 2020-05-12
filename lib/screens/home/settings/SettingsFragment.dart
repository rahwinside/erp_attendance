import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/changepassword/change_password_presenter.dart';
import 'package:flutter/material.dart';

FocusNode _focusNode = FocusNode();
final scaffoldKey = new GlobalKey<ScaffoldState>();
var username = "";
TextEditingController oldPassController = new TextEditingController();
TextEditingController newPassController1 = new TextEditingController();
TextEditingController newPassController2 = new TextEditingController();

final changePassFormKey = new GlobalKey<FormState>();

bool _isLoading = false;

class SettingsFragment extends StatefulWidget {
  SettingsFragment({Key key}) : super(key: key);

  @override
  _SettingsFragmentState createState() {
    return new _SettingsFragmentState();
  }
}

class _SettingsFragmentState extends State<SettingsFragment>
    implements ChangePasswordScreenContract {
  String _oldPassword, _newPassword1, _newPassword2;

  ChangePasswordScreenPresenter _presenter;

  _SettingsFragmentState() {
    _presenter = new ChangePasswordScreenPresenter(this);
  }

  void _submit() {
    final form = changePassFormKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      var db = new DatabaseHelper();
      db.getFirstUser().then((User user) {
        username = user.username;
//      print(username+oldPassController.text+newPassController1.text);
        _presenter.doUpdate(
            username, oldPassController.text, newPassController1.text);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var updateBtn = Padding(
      padding: EdgeInsets.only(top: 5),
      child: RaisedButton(
        onPressed: _submit,
        child: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
          ),
        ),
        color: Colors.deepPurple,
        splashColor: Colors.purple,
        elevation: 5.0,
      ),
    );

    return new Scaffold(
      key: scaffoldKey,
      body: new SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(left: 5, right: 5),
//                child: new Text(
//                  "Date of class",
//                  style: new TextStyle(
//                      fontSize: 12.0,
//                      color: const Color(0xFF000000),
//                      fontWeight: FontWeight.w200,
//                      fontFamily: "Poppins"),
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: new Text(
                  "Change Password",
                  style: new TextStyle(
                      fontSize: 20,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
//                decoration: new BoxDecoration(
//                  border: new Border.all(color: Colors.black38),
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                ),
                child: new Form(
                  key: changePassFormKey,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        onFieldSubmitted: (input) {
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        validator: (input) {
                          if (input.length < 8)
                            return 'Password must be minimum of 8 characters';
                        },
                        controller: oldPassController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                          ),
                          labelText: "Old password",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(5.0),
//                        ),
                        ),
                        obscureText: true,
                        textAlign: TextAlign.left,
                        onSaved: (val) => _oldPassword = val,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        onFieldSubmitted: (input) {
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        validator: (input) {
                          if (input.length < 8)
                            return 'Password must be minimum of 8 characters';
                        },
                        controller: newPassController1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                          ),
                          labelText: "New password",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(5.0),
//                        ),
                        ),
                        obscureText: true,
                        textAlign: TextAlign.left,
                        onSaved: (val) => _newPassword1 = val,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        focusNode: _focusNode,
                        validator: (input) {
                          if (input.length < 8)
                            return 'Password must be minimum of 8 characters';
                          if (input != newPassController1.text) {
                            return "Passwords don't match";
                          }
                        },
                        controller: newPassController2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                          ),
                          labelText: "Confirm new password",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(5.0),
//                        ),
                        ),
                        obscureText: true,
                        textAlign: TextAlign.left,
                        onSaved: (val) => _newPassword2 = val,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: new CircularProgressIndicator())
                      : updateBtn,
                ],
              ),
            ]),
      ),
    );
  }

  @override
  void onUpdateError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  Future<void> onUpdateSuccess(User user) async {
    _showSnackBar("Password has been updated");
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
  }
}
