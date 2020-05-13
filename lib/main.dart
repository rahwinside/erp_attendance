import 'package:attendance/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

void main() async {
  runApp(
    Phoenix(
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Communicator',
        theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          canvasColor: const Color(0xFFfafafa),
        ),
//        home: _defaultHome,
        routes: routes,
//        home: new HomeScreen(),
      ),
    ),
  );
}