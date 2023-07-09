// ignore_for_file: prefer_const_constructors, avoid_print

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localbiz1/screens/splash_screen.dart';
import 'package:localbiz1/utils/authentication.dart';

//Mobile App Code
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Authentication.initializeFirebase();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Authentication.initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'LocalBiz',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              //routes: AppRoutes.signin,
              //routes: AppRoutes.splashScreen,
              home: SplashScreen(), // Update to SplashScreen
            );
          }
          return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
        });
  }
}

//Web App Code
/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
        // Add your Firebase configuration values here
        apiKey: "AIzaSyBuD_taQ5FNMp3NjLi3S6V2pHRwL0LmD28",
        authDomain: "localbiz1-c13da.firebaseapp.com",
        projectId: "localbiz1-c13da",
        storageBucket: "localbiz1-c13da.appspot.com",
        messagingSenderId: "434848095913",
        appId: "1:434848095913:web:df1ee9bf19beb7ccb693b8"),
  );

  runApp(MyApp(
    initialization: Authentication.initializeFirebase(),
  ));
}

class MyApp extends StatelessWidget {
  final Future<void> initialization;

  const MyApp({Key? key, required this.initialization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalBiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: FutureBuilder(
          future: initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error); // Add this line to print the error message
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return SplashScreen();
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            );
          },
        ),
      ),
    );
  }
}*/
