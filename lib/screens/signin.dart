// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, sort_child_properties_last, prefer_final_fields, unused_field, unnecessary_null_comparison, unused_element
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/authentication.dart';
import 'reset_password.dart';
import 'signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';
import 'businessowner.dart';
import 'admin.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String _email = '';
  late String _password = '';
  bool _showError = false;
  bool _isInvalidCredentials = false;
  bool _isSigningIn = false;
  bool _isPasswordVisible = false;
  Timer? _timer;
  bool _isFingerprintSupported = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  void initState() {
    _checkFingerprintSupport();
    Authentication.initializeFirebase();
    Authentication.checkSignedIn(context);
    super.initState();
  }

  Future<void> _checkFingerprintSupport() async {
    bool isSupported = false;
    try {
      isSupported = await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Fingerprint support check error: $e');
    }

    setState(() {
      _isFingerprintSupported = isSupported;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Center(
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isInvalidCredentials)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AnimatedOpacity(
                      opacity: _isInvalidCredentials ? 1.0 : 0.0,
                      duration: const Duration(seconds: 5),
                      child: Text(
                        'Invalid credentials. Please try again.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        errorText:
                            _showEmailError ? 'Empty field not allowed' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                          _showEmailError = false;
                          _timer?.cancel();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        errorText: _showPasswordError
                            ? 'Empty field not allowed'
                            : null,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                          _showPasswordError = false;
                          _timer?.cancel();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.13),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ResetPassword()));
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 360,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: _isSigningIn
                        ? null
                        : () {
                            setState(() {
                              _isSigningIn = true;
                            });

                            if (_email.isEmpty || _password.isEmpty) {
                              setState(() {
                                _isSigningIn = false;
                                _showEmailError = _email.isEmpty;
                                _showPasswordError = _password.isEmpty;
                              });
                              return;
                            }

                            _timer?.cancel();
                            _timer = Timer(const Duration(seconds: 5), () {
                              setState(() {
                                _isSigningIn = false;
                                _isInvalidCredentials = false;
                              });
                            });

                            Authentication.signin(
                              context,
                              _email,
                              _password,
                              () {
                                setState(() {
                                  _isSigningIn = false;
                                  _isInvalidCredentials = true;
                                });
                              },
                            );
                          },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 360,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Color.fromARGB(255, 253, 253, 253),
                    ),
                    onPressed: () {
                      Authentication.signinWithGoogle(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            'assets/google.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sign in with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 9, 9, 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Don\'t have an account?'),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Signup()));
                  },
                  child: const Text(
                    'Sign up Now',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isFingerprintSupported
          ? Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () => _authenticateWithFingerprint(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 252, 251, 251),
                  padding: const EdgeInsets.all(20),
                  shape: CircleBorder(),
                  elevation: 0,
                ),
                child: Icon(
                  FontAwesomeIcons.fingerprint,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _authenticateWithFingerprint() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate with fingerprint to continue',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print('Fingerprint authentication error: $e');
    }

    if (isAuthenticated) {
      Authentication.signinWithGoogle(context: context);
    }
  }
}
