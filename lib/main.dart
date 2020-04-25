import 'package:attendance/routes.dart';
import 'package:attendance/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

void main() async {
  // Set default home.
//  Widget _defaultHome = new LoginScreen();
//
//  // Get result of the login function.
//  var db = new DatabaseHelper();
//  bool _result = await db.isLoggedIn();
//  if (_result) {
//    _defaultHome = new HomeScreen();
//  }
  runApp(
    Phoenix(
      child: new MaterialApp(
        title: 'Communicator',
        theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          canvasColor: const Color(0xFFfafafa),
        ),
//        home: _defaultHome,
        routes: routes,
//      home: new HomeScreen(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Communicator',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        canvasColor: const Color(0xFFfafafa),
      ),
      routes: routes,
//      home: new HomeScreen(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Communicator'),
//      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black26, Colors.white10],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Communicator",
                  style: new TextStyle(
                      fontSize: 23.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
                new Image.asset(
                  'images/licetlogo.png',
                  fit: BoxFit.fill,
                  width: 190.0,
                  height: 190.0,
                ),
                Form(
                  key: _formKey,
                  autovalidate: false,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      TextFormField(
                        style: TextStyle(
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
                        //keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: "Email address",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                          ),
                          hintText: "username@licet.ac.in",
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                          ),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                          ),
                          border: OutlineInputBorder(
                            gapPadding: 1.0,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                      ),
                      TextFormField(
                        style: TextStyle(
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
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        obscureText: true,
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 5),
                            child: RaisedButton(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                color: Colors.deepPurple,
                                splashColor: Colors.purple,
                                elevation: 5.0,
                                onPressed: () {
                                  if (userController.text == 'rah' &&
                                      passController.text == 'rah') {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  }
                                }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  ),
                ),
                new Text(
                  "Forgot your login details?",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                )
              ]),
        ),
      ),
    );
  }
}
