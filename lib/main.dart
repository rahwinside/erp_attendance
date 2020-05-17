import 'package:attendance/screens/home/AttendanceFragment/ModifyAttendanceFragment.dart';
import 'package:flutter/material.dart';

GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
      home: new ModifyAttendanceFragment(),
    ),
  );
}