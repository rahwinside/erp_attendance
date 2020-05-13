import 'dart:ui';

import 'package:attendance/auth.dart';
import 'package:attendance/data/authAPI_rest_ds.dart';
import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/login/login_screen_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

String username, auth_token;

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
  Image licetLogo;
  AssetImage backgroundImage = new AssetImage("images/landing.jpg");

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
//    resetUsers();
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
  void initState() {
    licetLogo = Image.asset(
      "images/licetlogo.png",
      fit: BoxFit.fill,
      width: 100.0,
      height: 100.0,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await precacheImage(licetLogo.image, context);
    await precacheImage(backgroundImage, context);
    super.didChangeDependencies();
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      print(context.toString());
      print(context.runtimeType);
//      checkForAuthStatus().then

      AuthRestDataSource api = new AuthRestDataSource();
      var db = new DatabaseHelper();
      db.getFirstUser().then((User user) {
        username = user.username;
        auth_token = user.auth_token;
        print(username + auth_token);
        api.auth(username, auth_token).then((bool res) {
          print(res.toString());
          print(res.runtimeType);
          if (res) {
            if (passController.text == "licet@123") {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                  '/changePassword', (Route<dynamic> route) => false)
                  .then((_) => formKey.currentState.reset());
//              SchedulerBinding.instance.addPostFrameCallback((_) async {
//                Navigator.of(context)
//                    .pushNamedAndRemoveUntil(
//                    '/changePassword', (Route<dynamic> route) => false)
//                    .then((_) => formKey.currentState.reset());
//              });
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false)
                  .then((_) => formKey.currentState.reset());
//              SchedulerBinding.instance.addPostFrameCallback((_) async {
//                Navigator.of(context)
//                    .pushNamedAndRemoveUntil(
//                    '/home', (Route<dynamic> route) => false)
//                    .then((_) => formKey.currentState.reset());
//              });
            }
          } else {
            var db = new DatabaseHelper();
            db.deleteUsers().then((dynamic val) {
              var authStateProvider = new AuthStateProvider();
              authStateProvider.notify(AuthState.LOGGED_OUT);
            });
          }
        });
      });
    }
    if (state == AuthState.LOGGED_OUT) {
      print(context.toString());
      print(context.runtimeType);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    }
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

    var loginForm = new Column(
      children: <Widget>[
        Expanded(
          flex: 97,
          child: new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundImage,
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
                        licetLogo,
                        new Text(
                          " Communicator",
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
                              if (!RegExp(
                                  r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(input))
                                return 'Check your email address';
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
                    _isLoading
                        ? Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: new CircularProgressIndicator())
                        : loginBtn,
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
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt.substring(11));
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar("Logged in");
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  Future<void> resetUsers() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
  }
}
