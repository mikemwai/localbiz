// business_owner.dart
// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:localbiz1/screens/admin.dart';
import 'package:localbiz1/screens/admin/orders.dart';
import 'package:localbiz1/screens/admin/payments.dart';
import 'package:localbiz1/screens/admin/profile_screen1.dart';
import 'package:localbiz1/screens/user/closedorders.dart';
import '../../utils/authentication.dart';
import '../homepage.dart';
import '../signin.dart';
import 'businesses.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreen3State createState() => _ProfileScreen3State();
}

class _ProfileScreen3State extends State<AdminProfileScreen> {
  String userEmail = ''; // Changed userEmail to email
  String userId = ''; // Add userId variable here

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? ''; // Changed userEmail to email
        userId = user.uid; // Set the userId value here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        // Wrap the ListView with Center widget
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId) // Assuming email is the document ID
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.data() == null) {
                // If the document with the provided email is not found or the data is null
                return Center(
                  child: Text('No profile data found'),
                );
              }

              final user = snapshot.data!.data()! as Map<String, dynamic>;
              final String? fname = user['fname'] as String?;
              final String? lname = user['lname'] as String?;
              final String? phoneno = user['phoneno'] as String?;
              final String? email = user['email'] as String?;

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
                            title: Text('First Name: $fname'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Last Name: $lname'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone Number: $phoneno'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('Email: $email'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 50, // Set the desired height here
                    width: MediaQuery.of(context).size.width *
                        0.80, // Set the desired width here7
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen1(
                              userId: userId,
                            ),
                          ),
                        );
                      },
                      child: Text('Update Profile'),
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
                backgroundColor: Colors
                    .white, // Adjust the background color of the circle avatar
                child: Icon(
                  Icons.account_circle, // Replace with the desired icon
                  size: 64, // Adjust the size of the icon as needed
                  color: Colors.blue, // Adjust the color of the icon
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
                userEmail, // Display the user's email retrieved from Firebase
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Admin(), // Replace with your ProfileScreen widget
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminProfileScreen(), // Replace with your ProfileScreen widget
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Businesses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BusinessesScreen(), // Replace with your BusinessesScreen widget
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart), // Add the Shopping Cart Icon
              title: const Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersAdmin(
                      userEmail: '',
                      userId: '',
                    ), // Replace with your BusinessesScreen widget
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.payment), // Add the Payment Icon
              title: const Text('Payments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentsAdmin(
                      userEmail: '',
                      userId: '',
                    ), // Replace with your BusinessesScreen widget
                  ),
                );
              },
            ),
            /*const Divider(),
            ListTile(
              leading: Icon(Icons.star), // Add the Star Icon
              title: const Text('Ratings'),
              onTap: () {
                // TODO: Implement the action for Ratings
              },
            ),*/
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
