import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Businessprofile extends StatefulWidget {
  const Businessprofile({Key? key, required this.email}) : super(key: key);
  final String email; // Define the named parameter email

  @override
  State<Businessprofile> createState() => _BusinessprofileState();
}

class _BusinessprofileState extends State<Businessprofile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _operatingHoursController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String? email = user.email;
    }
  }

  void _createBusiness() async {
    if (_formKey.currentState!.validate()) {
      // Get the current user ID.
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;

        // Create a document reference in the "businesses" collection using the user's email as the document ID.
        final documentReference = FirebaseFirestore.instance
            .collection('businesses')
            .doc(widget.email);

        // Get the business details from the text controllers.
        final String name = _nameController.text;
        final String category = _categoryController.text;
        final String phoneNo = _phoneController.text;
        final String operatingHours = _operatingHoursController.text;

        // Save the business details to Firestore.
        await documentReference.set({
          'name': name,
          'category': category,
          'phone_no': phoneNo,
          'operating_hours': operatingHours,
        });

        // Show a toast to indicate that the business profile has been added.
        Fluttertoast.showToast(
          msg: 'Business profile added successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue, // Set the background color of the toast
          textColor: Colors.white, // Set the text color of the toast
          fontSize: 16.0,
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Business Profile'),
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your business category';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phoneController,
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
                    controller: _operatingHoursController,
                    decoration:
                        const InputDecoration(labelText: 'Operating Hours'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your business operating hours';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: _createBusiness,
                    child: const Text('Add'),
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
