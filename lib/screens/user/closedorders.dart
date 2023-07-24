// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localbiz1/screens/businessowner.dart';
import 'package:localbiz1/screens/businessowner/businesspayments.dart';
import 'package:localbiz1/screens/businessowner/orders.dart';
import 'package:localbiz1/screens/homepage.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/screens/user/businesses.dart';
import 'package:localbiz1/screens/user/profile_screen3.dart';
import 'package:localbiz1/utils/authentication.dart';

class ClosedOrders extends StatefulWidget {
  const ClosedOrders({Key? key, required this.userId, required this.userEmail})
      : super(key: key);

  final String userId;
  final String userEmail;

  @override
  ClosedOrdersState createState() => ClosedOrdersState();
}

class ClosedOrdersState extends State<ClosedOrders> {
  bool isDrawerOpen = false;
  String userEmail = ''; // Changed userEmail to email

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
    // Retrieve the user's email from Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? ''; // Update the userEmail variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .snapshots(), // Retrieve all orders from the "orders" collection
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract order documents from the snapshot
          final orders = snapshot.data!.docs;

          // Build the table widget
          return Center(
            child: FractionallySizedBox(
              widthFactor:
                  0.80, // Set the desired width factor (75% in this case)
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height *
                        0.75, // Set the desired height
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 30.0,
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade300,
                        ),
                        columns: [
                          DataColumn(
                            label: Text('Business Email'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                          DataColumn(
                            label: Text('Customer Phone No'),
                          ),
                          DataColumn(
                            label: Text('Status'),
                          ),
                        ],
                        rows: orders.map((orderDoc) {
                          final order = orderDoc.data() as Map<String, dynamic>;
                          final email = order['email'] ??
                              'N/A'; // Handle null value with a default 'N/A'
                          final price = order['price'] ??
                              0; // Handle null value with a default value of 0
                          final phoneNo = order['phone_no'] ??
                              'N/A'; // Handle null value with a default 'N/A'
                          final status = order['status'] ??
                              'N/A'; // Handle null value with a default 'N/A'

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(email),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(price.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(phoneNo),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(status),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
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
              leading: Icon(Icons.shopping_cart), // Icon for payments
              title: const Text('Closed Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClosedOrders(
                      userEmail: '',
                      userId: '',
                    ),
                  ),
                );
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
