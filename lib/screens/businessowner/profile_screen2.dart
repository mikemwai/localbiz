import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({Key? key, required this.email}) : super(key: key);
  final String email; // Define the named parameter email

  @override
  State<ProfileScreen2> createState() => _ProfileScreenState2();
}

class _ProfileScreenState2 extends State<ProfileScreen2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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

      // Retrieve user details from Firestore using the provided userId
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(email)
          .get();

      if (snapshot.exists) {
        final business = snapshot.data() as Map<String, dynamic>;
        final String? name = business['name'] as String?;
        final String? category = business['category'] as String?;
        final String? phoneNo = business['phone_no'] as String?;
        final String? operatingHours = business['operating_hours'] as String?;

        setState(() {
          _nameController.text = name ?? '';
          _categoryController.text = category ?? '';
          _phoneController.text = phoneNo ?? '';
          _operatingHoursController.text = operatingHours ?? '';
        });
      }
    }
  }

  void _updateBusiness() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String category = _categoryController.text;
      final String phoneNo = _phoneController.text;
      final String operatingHours = _operatingHoursController.text;

      // TODO: Implement business update logic using Firestore
      updateBusinessInFirestore(name, email, category, phoneNo, operatingHours);

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  void updateBusinessInFirestore(String name, String email, String category,
      String phoneNo, String operatingHours) async {
    // Fetch the document ID associated with the provided email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs.first.id;

      // Update the business details using the retrieved document ID
      FirebaseFirestore.instance.collection('users').doc(widget.email).update({
        'name': name,
        'category': category,
        'phone_no': phoneNo,
        'operating_hours': operatingHours,
      });

      print('Business updated: name=$name, email=$email');
    } else {
      print('Business with email $email not found.');
    }
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
                /*SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: false, // Disable editing for the email TextField
                  ),
                ),*/
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
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50, // Replace with your desired height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      _updateBusiness(); // Call the _updateBusiness function to save the profile data
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
