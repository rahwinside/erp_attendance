import 'dart:ui';

import 'package:attendance/auth.dart';
import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/login/login_screen_presenter.dart';
import 'package:flutter/material.dart';

FocusNode _focusNode = FocusNode();
TextEditingController userController = TextEditingController();
TextEditingController passController = TextEditingController();

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(userController.text, passController.text);
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
    var loginBtn = Padding(
      padding: EdgeInsets.only(top: 5),
      child: RaisedButton(
        onPressed: _submit,
        child: Text(
          "Sign In",
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

    var loginForm = new Container(
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
              new Row(
                children: <Widget>[
                  new Image.asset(
                    'images/licetlogo.png',
                    fit: BoxFit.fill,
                    width: 100.0,
                    height: 100.0,
                  ),
                  new Text(
                    "Communicator",
                    style: new TextStyle(
                        fontSize: 23.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"),
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
                    new TextFormField(
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      validator: (input) {
                        if (!RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input)) return 'Check your email address';
                      },
                      onFieldSubmitted: (input) {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      controller: userController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: "Email address",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: "username@licet.ac.in",
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                        ),
//                        border: OutlineInputBorder(
//                          gapPadding: 1.0,
//                          borderRadius: BorderRadius.circular(5.0),
//                        ),
                      ),
                      textAlign: TextAlign.left,
                      onSaved: (val) => _username = val,
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
                      },
                      controller: passController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                        ),
                        labelText: "Password",
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
                      onSaved: (val) => _password = val,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              _isLoading ? Padding(padding: EdgeInsets.only(left: 5),
                  child: new CircularProgressIndicator()) : loginBtn,
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              new Text(
                "Forgot your login details?",
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
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: loginForm,
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
