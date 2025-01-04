import 'package:estilodevida/home_page.dart';
import 'package:estilodevida/ui/login/login_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = "/login";
  static const String home = "/home";
  static const String forgotpassword = "/home";
}

var routes = <String, WidgetBuilder>{
  Routes.login: (BuildContext context) => const LoginPage(),
  Routes.home: (BuildContext context) => const HomePage(),
};
