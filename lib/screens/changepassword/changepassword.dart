import 'dart:ui';

import 'package:attendance/auth.dart';
import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/changepassword/change_password_presenter.dart';
import 'package:flutter/material.dart';

var username = "";
FocusNode _focusNode = FocusNode();
TextEditingController newPassController = TextEditingController();
TextEditingController newPassController2 = TextEditingController();

class ChangePasswordScreen extends StatefulWidget {
  final String username;

  ChangePasswordScreen({Key key, @required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends State<ChangePasswordScreen>
    implements ChangePasswordScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password1, _password2;

  ChangePasswordScreenPresenter _presenter;

  ChangePasswordScreenState() {
    _presenter = new ChangePasswordScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      var db = new DatabaseHelper();
      db.getFirstUser().then((User user) {
        username = user.username;
        print(username + newPassController.text);
        _presenter.doUpdate(
            username, "licet@123", newPassController.text);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
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

    var loginForm = new Column(
      children: <Widget>[
        Expanded(
          flex: 97,
          child: new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/landing.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: new Text(
                            "Let's get you a new password!",
                            style: new TextStyle(
                                fontSize: 23.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: new Text(
                            "The default password needs to be changed for the safety of your account.",
                            style: new TextStyle(
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ],
                    ),
                    new Form(
                      key: formKey,
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
                            controller: newPassController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
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
                            onSaved: (val) => _password1 = val,
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
                              if (input != newPassController.text) {
                                return "Passwords don't match";
                              }
                            },
                            controller: newPassController2,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
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
                            onSaved: (val) => _password2 = val,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: new CircularProgressIndicator())
                        : updateBtn,
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    new Text(
                      "Skip for now",
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Poppins",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        new Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "Mer Community  |  MixSpace Internet Services",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: loginForm,
    );
  }

  @override
  void onUpdateError(String errorTxt) {
    _showSnackBar(errorTxt.substring(12));
    setState(() => _isLoading = false);
  }

  @override
  void onUpdateSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
