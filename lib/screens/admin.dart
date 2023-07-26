// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localbiz1/screens/admin/adminprofile_screen.dart';
import 'package:localbiz1/screens/admin/orders.dart';
import 'package:localbiz1/screens/admin/payments.dart';
import '../utils/authentication.dart';
import 'admin/businesses.dart';
import 'signin.dart';
import 'admin/profile_screen1.dart'; // Replace 'profile_screen.dart' with the actual file name

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

  final ThemeData customTheme = ThemeData(
    primaryColor: Colors.blue, // Replace with your desired primary color
    hintColor: Colors.teal, // Replace with your desired accent color
    fontFamily: 'Roboto', // Replace with your desired font
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  @override
  void initState() {
    super.initState();
    getUserEmail(); // Call getUserEmail() method to retrieve the user's email
    fetchRowCount(); // Call fetchRowCount() method to fetch the count of rows
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.group,
                                    size: 40,
                                    color: Theme.of(context)
                                        .primaryColor), // Add the Group Icon
                                SizedBox(height: 10),
                                Text(
                                  'Total Users',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$rowCount',
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BusinessesScreen(), // Replace with your BusinessesScreen widget
                        ),
                      );
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.business,
                                    size: 40,
                                    color: Theme.of(context)
                                        .primaryColor), // Add the Business Icon
                                SizedBox(height: 10),
                                Text(
                                  'Total Businesses',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$rowCount1',
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                  child: GestureDetector(
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart,
                                    size: 40,
                                    color: Theme.of(context)
                                        .primaryColor), // Add the Shopping Cart Icon
                                SizedBox(height: 10),
                                Text(
                                  'Total Orders',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$rowCount2',
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                  child: GestureDetector(
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment,
                                    size: 40,
                                    color: Theme.of(context)
                                        .primaryColor), // Add the Payment Icon
                                SizedBox(height: 10),
                                Text(
                                  'Total Payments',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$rowCount3',
                                  style: Theme.of(context).textTheme.bodyLarge,
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

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  bool isDrawerOpen = false;
  String userEmail = ''; // Declare userEmail variable

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

  @override
  void initState() {
    super.initState();
    getUserEmail(); // Call getUserEmail() method to retrieve the user's email
  }

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
                            label: Text('First Name'),
                          ),
                          DataColumn(
                            label: Text('Last Name'),
                          ),
                          DataColumn(
                            label: Text('Email'),
                          ),
                          DataColumn(
                            label: Text('Phone Number'),
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
                          final fname = user['fname'];
                          final lname = user['lname'];
                          final email = user['email'];
                          final phoneno = user['phoneno'];
                          final role = user['role'];

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(fname),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(lname),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(email),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(phoneno),
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
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // If the user document does not exist, show an error message and return.
    if (!userDoc.exists) {
      Fluttertoast.showToast(
        msg: 'User document with ID $userId does not exist.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Delete the user from Firebase Authentication.
    /*try {
      await FirebaseAuth.instance.currentUser!.delete();
      print('The user has been deleted from Firebase Authentication.');
    } on FirebaseAuthException catch (e) {
      // Handle the exception for Firebase Authentication.
      Fluttertoast.showToast(
        msg: 'Failed to delete user from Authentication. ${e.message}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }*/

    // Delete user document from Firestore.
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print('Deleted user with ID: $userId from Firestore.');
    } catch (e) {
      // Handle the exception for Firestore.
      Fluttertoast.showToast(
        msg: 'Failed to delete user from Firestore. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Show a success message using FlutterToast.
    Fluttertoast.showToast(
      msg: 'The user has been deleted successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    // Optionally, you can navigate back to the user screen here if needed.
    //Navigator.pop(context);
  } catch (e) {
    print('Error deleting user: $e');
    // Show an error message using FlutterToast.
    Fluttertoast.showToast(
      msg: 'Failed to delete user. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
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
              DropdownButtonFormField<String>(
                value: role,
                items: [
                  DropdownMenuItem(
                    value: 'normal_user',
                    child: Text('Normal User'),
                  ),
                  DropdownMenuItem(
                    value: 'business_owner',
                    child: Text('Business Owner'),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Admin'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    role = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
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
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
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
      final String fname = user['fname'];
      final String lname = user['lname'];
      final String email = user['email'];
      final String phoneno = user['phoneno'];
      final String role = user['role'];

      setState(() {
        _fnameController.text = fname;
        _lnameController.text = lname;
        _emailController.text = email;
        _phonenoController.text = phoneno;
        _roleController.text = role;
      });
    }
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      final String fname = _fnameController.text;
      final String lname = _lnameController.text;
      final String email = _emailController.text;
      final String phoneno = _phonenoController.text;
      final String role = _roleController.text;

      // TODO: Implement user update logic using Firestore
      updateUserInFirestore(fname, lname, phoneno, email, role);

      // Show a FlutterToast to indicate that the user has been updated
      Fluttertoast.showToast(
        msg: 'User updated!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2, // Adjust the duration as needed
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void updateUserInFirestore(
      String fname, String lname, String phoneno, String email, String role) {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'fname': fname,
      'lname': lname,
      'email': email,
      'phoneno': phoneno,
      'role': role,
    });
    print('User updated: email=$email');
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
                    controller: _fnameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the first name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _lnameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the last name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phonenoController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: DropdownButtonFormField<String>(
                    value: _roleController.text,
                    decoration: InputDecoration(labelText: 'Role'),
                    items: [
                      DropdownMenuItem(
                        value: 'normal_user',
                        child: Text('Normal User'),
                      ),
                      DropdownMenuItem(
                        value: 'business_owner',
                        child: Text('Business Owner'),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _roleController.text = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a role';
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
