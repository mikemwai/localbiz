// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_import

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz1/screens/signin.dart';
import '../app_export.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the login page after 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin()),
      );
    });

    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: ColorConstant.whiteA700,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgSplashscreen,
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromARGB(255, 8, 8, 8)
                    .withOpacity(0.5), // Adjust the opacity as needed
                BlendMode.srcOver,
              ),
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: getPadding(
              left: 75,
              right: 75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: getPadding(
                    bottom: 5,
                  ),
                  child: Text(
                    "LocalBiz",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 253, 253),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
