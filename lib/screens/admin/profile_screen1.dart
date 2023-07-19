import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ProfileScreen1> createState() => _ProfileScreenState1();
}

class _ProfileScreenState1 extends State<ProfileScreen1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _phonenoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Retrieve user details from Firestore using the provided userId
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final user = snapshot.data() as Map<String, dynamic>;
        final String? fname = user['fname'] as String?;
        final String? lname = user['lname'] as String?;
        final String? phoneno = user['phoneno'] as String?;
        final String? email = user['email'] as String?;

        setState(() {
          _fnameController.text = fname ?? '';
          _lnameController.text = lname ?? '';
          _phonenoController.text = phoneno ?? '';
          _emailController.text = email ?? '';
        });
      }
    }
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      final String fname = _fnameController.text;
      final String lname = _lnameController.text;
      final String phoneno = _phonenoController.text;
      final String email = _emailController.text;

      // TODO: Implement user update logic using Firestore
      updateUserInFirestore(fname, lname, phoneno, email);

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void updateUserInFirestore(
      String fname, String lname, String phoneno, String email) {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'fname': fname,
      'lname': lname,
      'phoneno': phoneno,
      'email': email,
    });
    print('User updated: email=$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _fnameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _lnameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phonenoController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50, // Replace with your desired height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      _updateUser(); // Call the _updateUser function to save the profile data
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
