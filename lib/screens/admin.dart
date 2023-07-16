// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_const_constructors

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
                    child: SizedBox(
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
                    child: SizedBox(
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
                    child: SizedBox(
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
                    child: SizedBox(
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
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),*/
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
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),*/
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Orders'),
              onTap: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),*/
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Payments'),
              onTap: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersScreen(),
                  ),*/
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Ratings'),
              onTap: () {
                /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Signin(),
                  ));*/
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: toggleDrawer,
        child: Icon(isDrawerOpen ? Icons.close : Icons.menu),
      ),*/
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

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
                        columnSpacing:
                            30.0, // Adjust the spacing between columns
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade300,
                        ),
                        columns: [
                          DataColumn(
                            label: Text('Email'),
                          ),
                          DataColumn(
                            label: Text('Role'),
                          ),
                          DataColumn(
                            label: Text('Action'),
                          ),
                        ],
                        rows: users.map((userDoc) {
                          final user = userDoc.data() as Map<String, dynamic>;
                          final email = user['email'];
                          final role = user['role'];

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(email),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(role),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                buildActionWidget(context, userDoc.id, role),
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
            deleteUser(context, userId); // Pass the BuildContext parameter
          },
        ),
      ],
    );
  }

  void navigateToCreateUserScreen(BuildContext context) {
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

  void deleteUser(BuildContext context, String userId) async {
    try {
      // Check if the user document exists.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // If the user document does not exist, do not delete it.
      if (!userDoc.exists) {
        print('User document with ID $userId does not exist.');
        return;
      }

      // Delete the user.
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        print('The user has been deleted.');
      } on FirebaseAuthException catch (e) {
        // Handle the exception.
        print(e.message);
      }

      // Delete user from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print('Deleted user with ID: $userId');

      // Navigate back to the user screen
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting user: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete user. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

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

  String? role;

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;

      // Initialize the role variable.
      role = _roleController.text;

      try {
        // Create a new user with email and password.
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: 'password');

        // Get the user id.
        final uid = userCredential.user!.uid;

        // Create a document reference in Firestore.
        final documentReference =
            FirebaseFirestore.instance.collection('users').doc(uid);

        // Set the document data.
        Map<String, dynamic> data = {
          'email': email,
          'role': role,
        };

        // Write the document to Firestore.
        await documentReference.set(data);

        // Navigate back to the user screen
        Navigator.pop(context);

        // Send a password reset email after the user is created.
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } catch (e) {
        // Handle errors here
        print('Error creating user: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create user. Please try again.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
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

class UpdateUserScreen extends StatefulWidget {
  final String userId;

  const UpdateUserScreen(this.userId, {super.key});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    // Retrieve user details from Firestore using the provided userId
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      final user = snapshot.data() as Map<String, dynamic>;
      final String email = user['email'];
      final String role = user['role'];

      setState(() {
        _emailController.text = email;
        _roleController.text = role;
      });
    }
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String role = _roleController.text;

      // TODO: Implement user update logic using Firestore
      updateUserInFirestore(email, role);

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void updateUserInFirestore(String email, String role) {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'email': email,
      'role': role,
    });
    print('User updated: email=$email, role=$role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(labelText: 'Role'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a role';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50, // Replace with your desired height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _updateUser,
                    child: Text('Update User'),
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
