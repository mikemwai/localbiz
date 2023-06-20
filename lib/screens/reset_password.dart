import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/authentication.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String _email;
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          SizedBox(
            width: 360,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  Authentication.resetPassword(context, _email);
                  Fluttertoast.showToast(
                    msg: "A reset email has been sent to you", // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER, // location

                    timeInSecForIosWeb: 2,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Request Reset',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 360,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Go Back!',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
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
