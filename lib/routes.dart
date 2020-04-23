import 'package:attendance/screens/home/home_page.dart';
import 'package:attendance/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/': (BuildContext context) => new LoginScreen(),
};
