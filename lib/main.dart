import 'package:attendance/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Communicator',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new LoginScreen(),
    ),
  );
}