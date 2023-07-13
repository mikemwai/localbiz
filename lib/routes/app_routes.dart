// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:localbiz1/screens/businessowner.dart';
import 'package:localbiz1/screens/homepage.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/screens/splash_screen.dart';
import 'package:localbiz1/screens/admin.dart';

class AppRoutes {
  static const String splashScreen = '/splashscreen';
  static const String signin = '/signin';
  static const String admin = '/admin';
  static const String businessowner = '/businessowner';
  static const String homepage = '/homepage';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    // ignore: prefer_const_constructors
    signin: (context) => Signin(),

    admin: (context) => Admin(),

    businessowner: (context) => BusinessOwner(),

    homepage: (context) => HomePage(),
  };
}
