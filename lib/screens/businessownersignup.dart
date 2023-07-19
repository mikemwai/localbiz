// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/screens/signup.dart';
import '../utils/authentication.dart';

class BusinessSignup extends StatefulWidget {
  const BusinessSignup({Key? key}) : super(key: key);

  @override
  State<BusinessSignup> createState() => _BusinessSignupState();
}

class _BusinessSignupState extends State<BusinessSignup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  bool _showPasswordError = false;
  bool _showEmailError = false;
  Color _passwordBorderColor = Colors.grey;
  Color _emailBorderColor = Colors.grey;
  bool _isPasswordVisible = false; // Track password visibility
  late String _confirmPassword = '';
  bool _isConfirmPasswordVisible = false;
  bool _passwordsMatch = true; // Variable to track password match state
  bool _showError = false;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Center(
                child: Text(
                  'Business Registration',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      errorText:
                          _showEmailError ? 'Invalid email format' : null,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        borderSide: BorderSide(color: _emailBorderColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showEmailError = !_isEmailValid(value);
                        _emailBorderColor =
                            _showEmailError ? Colors.red : Colors.green;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      errorText: _showPasswordError
                          ? 'Make password more secure by using: \n *At least 8 characters, capital letters or symbols.'
                          : null,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        borderSide: BorderSide(color: _passwordBorderColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
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
                        _showPasswordError = !_isPasswordValid(value);
                        _passwordBorderColor =
                            _showPasswordError ? Colors.red : Colors.green;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextField(
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Confirm your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      errorText: !_passwordsMatch && _showError
                          ? 'Passwords do not match'
                          : null,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value.trim();
                        _passwordsMatch = _passwordController.text
                                .trim()
                                .isNotEmpty &&
                            _confirmPassword == _passwordController.text.trim();
                        _showError = _showError ||
                            (!_passwordsMatch && _confirmPassword.isNotEmpty);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    _registerUser();
                  },
                  child: const Text(
                    'Sign up with email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Go Back!',
                    style: TextStyle(
                      fontSize: 18,
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

  bool _isPasswordValid(String value) {
    if (value.length < 8) {
      return false;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }
    return true;
  }

  bool _isEmailValid(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }

  void _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final userExists = await Authentication.checkUserExists(email);

    if (userExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Error'),
            content: const Text('User already exists.'),
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
    } else {
      Authentication.businesssignup(context, email, password);
      _showSuccessSnackBar(); // Show success snackbar
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Business Registration successful!'), // Message to display
        duration:
            Duration(seconds: 2), // Duration for which the snackbar is visible
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
