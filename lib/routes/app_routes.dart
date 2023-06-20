import 'package:flutter/material.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/screens/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashscreen';
  static const String signin = '/signin';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    // ignore: prefer_const_constructors
    signin: (context) => Signin(),
  };
}
