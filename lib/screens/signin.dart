// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, sort_child_properties_last, prefer_final_fields, unused_field
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/authentication.dart';
import 'reset_password.dart';
import 'signup.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String _email = '';
  late String _password = '';
  bool _showError = false;
  bool _isInvalidCredentials = false; // Track invalid credentials
  bool _isSigningIn = false; // Variable to track if the user is signing in
  bool _isPasswordVisible = false;
  Timer? _timer;
  bool _isFingerprintSupported = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  // Add these flags for error messages
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
        // Wrap the Scaffold with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                        duration: const Duration(
                            seconds: 5), // Change the duration to 3 seconds
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your email address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      errorText:
                          _showEmailError ? 'Empty field not allowed' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                        _showEmailError =
                            false; // Clear the error message when the user starts typing
                        _timer
                            ?.cancel(); // Cancel the timer when the email is being changed
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      errorText:
                          _showPasswordError ? 'Empty field not allowed' : null,
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
                        _showPasswordError =
                            false; // Clear the error message when the user starts typing
                        _timer
                            ?.cancel(); // Cancel the timer when the password is being changed
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResetPassword()));
                        },
                        child: const Text(
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
                          ? null // Disable button if already signing in
                          : () {
                              setState(() {
                                _isSigningIn = true;
                              });

                              if (_email.isEmpty || _password.isEmpty) {
                                setState(() {
                                  _isSigningIn = false;
                                  _showEmailError = _email
                                      .isEmpty; // Show email error if empty
                                  _showPasswordError = _password
                                      .isEmpty; // Show password error if empty
                                });
                                return;
                              }

                              _timer?.cancel();
                              _timer = Timer(const Duration(seconds: 5), () {
                                setState(() {
                                  _isSigningIn = false;
                                  _isInvalidCredentials =
                                      false; // Reset invalid credentials
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
            ],
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
