// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

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
  late String _email, _password;

  @override
  void initState() {
    Authentication.initializeFirebase();
    Authentication.checkSignedIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          centerTitle: true,
          //backgroundColor: Colors.black45,
          title: const Text('LocalBiz'),
        ),*/
        body: ListView(
      padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
      children: [
        Column(
          children: [
            const SizedBox(
              height: 100,
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
            /*const Divider(
                  thickness: 2,
                ),*/
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 15), // Add right margin here
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
              //width: MediaQuery.of(context).size.width,
              width: 360,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    Authentication.signin(context, _email, _password);
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
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
                  backgroundColor: Color.fromARGB(255, 253, 253,
                      253), // Set the desired background color here
                ),
                onPressed: () {
                  Authentication.signinWithGoogle(context: context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the children horizontally
                  children: [
                    Container(
                      width: 25, // Set the desired width for the image
                      height: 25, // Set the desired height for the image
                      child: Image.asset(
                        'assets/google.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add spacing between the image and text
                    const Text(
                      'Sign in with Google',
                      textAlign:
                          TextAlign.center, // Center the text horizontally
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Signup()));
              },
              child: const Text(
                'Sign up Now',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
