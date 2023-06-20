// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

import '../utils/authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
          centerTitle: true,
          elevation: 10,
          //backgroundColor: const Color.fromARGB(115, 0, 0, 0),
          title: const Text('LocalBiz')),*/
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 130,
            ),
            const Center(
              child: Text(
                'Registration',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 360,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  Authentication.signup(context, _email, _password);
                },
                child: const Text(
                  'Sign up with email',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
