// business_owner.dart
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:localbiz1/screens/businessowner/businesspayments.dart';
import 'package:localbiz1/screens/businessowner/businessprofile.dart';
import 'package:localbiz1/screens/businessowner/orders.dart';
import '../utils/authentication.dart';
import 'businessowner/profile_screen2.dart';
import 'signin.dart';

class BusinessOwner extends StatefulWidget {
  const BusinessOwner({Key? key}) : super(key: key);

  @override
  State<BusinessOwner> createState() => _BusinessOwnerState();
}

class _BusinessOwnerState extends State<BusinessOwner> {
  bool isDrawerOpen = false;
  String email = ''; // Changed userEmail to email

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? ''; // Changed userEmail to email
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner Page'),
      ),
      body: Center(
        // Wrap the ListView with Center widget
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('businesses')
                .doc(email) // Assuming email is the document ID
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                // If the document with the provided email is not found or does not exist
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No business profile found.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the screen to add business profile
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Businessprofile(
                                email: email, // Changed userEmail to email
                              ),
                            ),
                          );
                        },
                        child: Text('Add Business Profile'),
                      ),
                    ],
                  ),
                );
              }

              final business = snapshot.data!.data() as Map<String, dynamic>;
              final String? name = business['name'] as String?;
              final String? category = business['category'] as String?;
              final String? phoneNo = business['phone_no'] as String?;
              final String? operatingHours =
                  business['operating_hours'] as String?;

              return ListView(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Name: $name'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.category),
                            title: Text('Category: $category'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone Number: $phoneNo'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('Operating Hours: $operatingHours'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 50, // Set the desired height here
                    width: MediaQuery.of(context).size.width *
                        0.70, // Set the desired width here7
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen2(
                              email: '',
                            ),
                          ),
                        );
                      },
                      child: Text('Update Business Profile'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  size: 64,
                  color: Colors.blue,
                ),
              ),
              accountName: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              accountEmail: Text(
                email, // Changed userEmail to email
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Business Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessOwner(),
                  ),
                );
              },
            ),
            /*const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: const Text('Products'),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Order(),
                  ),
                );
              },*/
            ),*/
            const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: const Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderView(
                      userEmail: '',
                      userId: '',
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessPayments(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Authentication.signout(context: context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Signin(),
                  ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
