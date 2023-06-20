import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'utils/authentication.dart';
//import '../routes/app_routes.dart';

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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange));
        });
  }
}
