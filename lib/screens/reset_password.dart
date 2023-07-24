import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/authentication.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _email = ''; // Initialize the _email variable with an empty string

  void _requestPasswordReset() {
    if (_email.trim().isEmpty) {
      _showToast("Password Reset Failed! Try Again.");
    } else {
      // Perform the password reset action
      Authentication.resetPassword(context, _email);
      _showToast("A reset email has been sent to you");
      Navigator.of(context).pop();
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Reset Password'),
      ),*/
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          const Center(
            child: Text(
              'Reset Password',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
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
              onPressed: _requestPasswordReset,
              child: const Text(
                'Request Reset',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
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
    );
  }
}
