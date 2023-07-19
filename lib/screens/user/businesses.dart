// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:localbiz1/screens/user/profile_screen3.dart';

import '../../utils/authentication.dart';
import '../homepage.dart';
import '../signin.dart';

class BusinessesDashboard extends StatefulWidget {
  const BusinessesDashboard({Key? key}) : super(key: key);

  @override
  _BusinessesDashboardState createState() => _BusinessesDashboardState();
}

class _BusinessesDashboardState extends State<BusinessesDashboard> {
  String email = ''; // Changed userEmail to email
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
        email = user.email ?? ''; // Changed userEmail to email
        userId = user.uid; // Set the userId value here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Businesses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final businesses = snapshot.data!.docs;
            return ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business =
                    businesses[index].data() as Map<String, dynamic>;
                final String name = business['name'] ?? '';
                final String category = business['category'] ?? '';
                final String phoneNo = business['phone_no'] ?? '';
                final String operatingHours = business['operating_hours'] ?? '';

                return BusinessCard(
                  name: name,
                  category: category,
                  phoneNo: phoneNo,
                  operatingHours: operatingHours,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
                'User Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              accountEmail: Text(
                email, // Display the user's email retrieved from Firebase
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
                        HomePage(), // Replace with your ProfileScreen widget
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('View Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen3(), // Replace with your ProfileScreen widget
                  ),
                );
              },
            ),
            /*ListTile(
              leading: Icon(Icons.person), // Icon for updating profile
              title: const Text('Update Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: '',
                    ),
                  ),
                );
              },
            ),*/
            const Divider(),
            ListTile(
              leading: Icon(Icons.business), // Icon for saved businesses
              title: const Text('Businesses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessesDashboard(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.payment), // Icon for payments
              title: const Text('Payments'),
              onTap: () {
                // TODO: Implement the navigation to the payments screen
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout), // Icon for signing out
              title: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Authentication.signout(context: context);
                  try {
                    // After successful sign-out, navigate to the sign-in page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Signin()),
                      (route) =>
                          false, // Remove all other routes from the stack
                    );
                  } catch (e) {
                    print('Error signing out: $e');
                    // Handle any sign-out errors here
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessCard extends StatelessWidget {
  final String name;
  final String category;
  final String phoneNo;
  final String operatingHours;

  const BusinessCard({super.key, 
    required this.name,
    required this.category,
    required this.phoneNo,
    required this.operatingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.business),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $category'),
            Text('Phone Number: $phoneNo'),
            Text('Operating Hours: $operatingHours'),
          ],
        ),
      ),
    );
  }
}
