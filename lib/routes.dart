import 'package:attendance/screens/changepassword/changepassword.dart';
import 'package:attendance/screens/home/home_page.dart';
import 'package:attendance/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/clickable.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/': (BuildContext context) => new NameClickable(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/changePassword': (BuildContext context) => new ChangePasswordScreen(),
//  '/': (BuildContext context) => new LoginScreen(),

};
