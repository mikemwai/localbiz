// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:localbiz1/screens/businessowner.dart';
import 'package:localbiz1/screens/homepage.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/screens/splash_screen.dart';
import 'package:localbiz1/screens/admin.dart';
import 'package:localbiz1/screens/user/businesses.dart';
import '../screens/admin/profile_screen1.dart';
import '../screens/businessowner/profile_screen2.dart';

class AppRoutes {
  static const String splashScreen = '/splashscreen';
  static const String signin = '/signin';
  static const String admin = '/admin';
  static const String businessowner = '/businessowner';
  static const String homepage = '/homepage';
  static const String profilescreen1 = 'admin/ProfileScreen1';
  static const String profilescreen2 = 'businessowner/ProfileScreen2';
  static const String businesses = 'user/BusinessesDashboard';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    // ignore: prefer_const_constructors
    signin: (context) => Signin(),

    admin: (context) => Admin(),

    businessowner: (context) => BusinessOwner(),

    homepage: (context) => HomePage(),

    profilescreen1: (context) => ProfileScreen1(
          userId: '',
        ),

    profilescreen2: (context) => ProfileScreen2(
          email: '',
        ),

    businesses: (context) => BusinessesDashboard(),
  };
}
