// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/authentication.dart';
import 'signin.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool isDrawerOpen = false;
  String userEmail = ''; // Declare userEmail variable
  int rowCount = 0; // Variable to hold the count of rows
  int rowCount1 = 0; // Variable to hold the count of rows
  int rowCount2 = 0; // Variable to hold the count of rows
  int rowCount3 = 0; // Variable to hold the count of rows

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
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

  Future<void> fetchRowCount() async {
    // Fetch the count of rows from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your Firestore collection name
        .get();
    setState(() {
      rowCount =
          snapshot.size; // Update the rowCount variable with the count of rows
    });

    QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('businesses') // Replace with your Firestore collection name
        .get();
    setState(() {
      rowCount1 =
          snapshot1.size; // Update the rowCount variable with the count of rows
    });

    QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('orders') // Replace with your Firestore collection name
        .get();
    setState(() {
      rowCount2 =
          snapshot2.size; // Update the rowCount variable with the count of rows
    });

    QuerySnapshot snapshot3 = await FirebaseFirestore.instance
        .collection('payments') // Replace with your Firestore collection name
        .get();
    setState(() {
      rowCount3 =
          snapshot3.size; // Update the rowCount variable with the count of rows
    });
  }

  @override
  void initState() {
    super.initState();
    getUserEmail(); // Call getUserEmail() method to retrieve the user's email
    fetchRowCount(); // Call fetchRowCount() method to fetch the count of rows
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the "Users" screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UsersScreen(),
                                ),
                              );
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Users',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$rowCount',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement the action for the second card
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Businesses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$rowCount1',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement the action for the third card
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Orders',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$rowCount2',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement the action for the fourth card
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Payments',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$rowCount3',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              title: const Text('View Profile'),
              onTap: () {
                // TODO: Implement the profile screen navigation
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Users'),
              onTap: () {
                // Navigate to the "Users" screen
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
              title: const Text('Businesses'),
              onTap: () {
                // TODO: Implement the navigation to the businesses screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Orders'),
              onTap: () {
                // TODO: Implement the navigation to the orders screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Payments'),
              onTap: () {
                // TODO: Implement the navigation to the saved businesses screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Ratings'),
              onTap: () {
                // TODO: Implement the navigation to the ratings screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: toggleDrawer,
        child: Icon(isDrawerOpen ? Icons.close : Icons.menu),
      ),*/
    );
  }
}

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract user documents from the snapshot
          final users = snapshot.data!.docs;

          // Build the table widget
          return DataTable(
            columns: [
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Action')),
            ],
            rows: users.map((userDoc) {
              final user = userDoc.data() as Map<String, dynamic>;
              final email = user['email'];
              final role = user['role'];

              return DataRow(
                cells: [
                  DataCell(Text(email)),
                  DataCell(Text(role)),
                  DataCell(buildActionWidget(context, userDoc.id, role)),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: Implement create user functionality
          navigateToCreateUserScreen(context);
        },
      ),
    );
  }

  Widget buildActionWidget(BuildContext context, String userId, String role) {
    if (role == 'admin') {
      return Text('N/A');
    } else {
      return Row(
        children: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              navigateToUpdateUserScreen(context, userId);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteUser(userId);
            },
          ),
        ],
      );
    }
  }

  void navigateToCreateUserScreen(BuildContext context) {
    // TODO: Implement navigation to the create user screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserScreen()),
    );
  }

  void navigateToUpdateUserScreen(BuildContext context, String userId) {
    // TODO: Implement navigation to the update user screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateUserScreen(userId)),
    );
  }

  void deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
    print('Deleted user with ID: $userId');
  }
}

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String role = _roleController.text;

      // TODO: Implement user creation logic using Firestore
      createUserInFirestore(email, role);

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void createUserInFirestore(String email, String role) {
    FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'role': role,
    });
    print('User created: email=$email, role=$role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a role';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createUser,
                child: Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateUserScreen extends StatelessWidget {
  final String userId;

  UpdateUserScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    // TODO: Build the update user screen UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Center(
        child: Text('Update User with ID: $userId'),
      ),
    );
  }
}
