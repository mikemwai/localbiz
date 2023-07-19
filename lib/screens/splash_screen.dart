// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:lottie/lottie.dart';
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
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                padding: getPadding(
                  left: 75,
                  right: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: getPadding(
                        bottom: 5,
                        right:
                            0, // Adjust the value to adjust how far the text is from the right margin
                      ),
                      child: Text(
                        "LocalBiz",
                        overflow: TextOverflow.ellipsis,
                        //textAlign: TextAlign.center,
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
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 150.0,
                    width: 150.0,
                    child: LottieBuilder.asset(
                      'assets/animassets/mapanimation.json',
                      // Replace with the correct path to your animation JSON file
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
