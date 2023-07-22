// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_const_constructors, unused_import, avoid_web_libraries_in_flutter

//import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/homepage.dart';
import '../screens/signin.dart';
import '../screens/verifyscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/admin.dart';
import '../screens/businessowner.dart';

class Authentication {
  static void checkSignedIn(BuildContext context) {
    Authentication.initializeFirebase();
    //if logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      route(context); // Pass the context parameter to the route method
      //Navigator.of(context).pushReplacement(
      //MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<void> signinWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn(
      // Set your app's client ID
      clientId:
          '434848095913-hu23b995nmte1famb20p8scvf4t3pcgm.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // Get the user details from the UserCredential object
        final User? user = userCredential.user;

        if (user != null) {
          // Check if the user already exists in the 'users' collection
          final userDocRef =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          final userDocSnapshot = await userDocRef.get();

          if (!userDocSnapshot.exists) {
            // If the user doesn't exist, add them to the 'users' collection
            await userDocRef.set({
              'fname': '',
              'lname': '',
              'phoneno': '',
              'email': user.email,
              'role': 'normal_user',
            });
          }
        }

        route(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        // );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle error
          print('account exists with different credential');
        } else if (e.code == 'invalid-credential') {
          // handle error
          print('invalid credential');
        }
      } catch (e) {
        // handle error
        print('something else');
      }
    }
  }

  static Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signup(
    BuildContext context,
    String email,
    String password,
    //String userId,
  ) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new user with email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user id.
      final uid = userCredential.user!.uid;

      // Create a document reference in Firestore.
      final documentReference =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Set the document data.
      Map<String, dynamic> data = {
        'fname': '',
        'lname': '',
        'phoneno': '',
        'email': email,
        'role': 'normal_user',
      };

      // Write the document to Firestore.
      await documentReference.set(data);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerifyScreen()),
      );
    } catch (error) {
      // Handle signup errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Error'),
            content: Text('Failed to sign up: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      print('Error signing up: $error');
    }
  }

  static Future<void> businesssignup(
    BuildContext context,
    String email,
    String password,
    //String userId,
  ) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new user with email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user id.
      final uid = userCredential.user!.uid;

      // Create a document reference in Firestore.
      final documentReference =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Set the document data.
      Map<String, dynamic> data = {
        'fname': '',
        'lname': '',
        'phoneno': '',
        'email': email,
        'role': 'business_owner',
      };

      // Write the document to Firestore.
      await documentReference.set(data);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerifyScreen()),
      );
    } catch (error) {
      // Handle signup errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Error'),
            content: Text('Failed to sign up: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      print('Error signing up: $error');
    }
  }

  static void signin(BuildContext context, String email, String password,
      VoidCallback onError) {
    final auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: email, password: password).then((_) {
      //Navigator.of(context).pushReplacement(
      route(context); // Pass the context parameter to the route method
      //MaterialPageRoute(builder: (context) => const HomePage()),
      //);
    }).catchError((error) {
      onError(); // Invoke the provided onError callback if authentication fails
    });
  }

  static void resetPassword(BuildContext context, String email) {
    final auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: email);
  }

  static Future<bool> checkUserExists(String email) async {
    final auth = FirebaseAuth.instance;
    try {
      final methods = await auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  static Future<void> route(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (documentSnapshot.exists) {
      if (documentSnapshot.get('role') == 'normal_user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (documentSnapshot.get('role') == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Admin()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusinessOwner()),
        );
      }
    } else {
      print('Document does not exist in the database');
    }
  }
}
