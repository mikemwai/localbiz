// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison, non_constant_identifier_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localbiz1/screens/admin.dart';
import 'package:localbiz1/screens/admin/adminprofile_screen.dart';
import 'package:localbiz1/screens/admin/orders.dart';
import 'package:localbiz1/screens/admin/payments.dart';
import 'package:localbiz1/screens/admin/profile_screen1.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/utils/authentication.dart';

class BusinessesScreen extends StatefulWidget {
  const BusinessesScreen({Key? key}) : super(key: key);

  @override
  State<BusinessesScreen> createState() => BusinessesScreenState();
}

class BusinessesScreenState extends State<BusinessesScreen> {
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
        title: Text('Businesses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract businesses documents from the snapshot
          final businesses = snapshot.data!.docs;

          if (businesses.isEmpty) {
            return Center(
              child: Text('No businesses found.'),
            );
          }

          // Build the table widget
          return Center(
            child: FractionallySizedBox(
              widthFactor: 0.80,
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
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 30.0,
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade300,
                        ),
                        columns: [
                          DataColumn(
                            label: Text('Business Name'),
                          ),
                          DataColumn(
                            label: Text('Category'),
                          ),
                          DataColumn(
                            label: Text('Phone No'),
                          ),
                          DataColumn(
                            label: Text('Operating Hours'),
                          ),
                          DataColumn(
                            label: Text('Email'),
                          ),
                          DataColumn(
                            label: Text('Action'),
                          ),
                        ],
                        rows: businesses.map((businessDoc) {
                          final business =
                              businessDoc.data() as Map<String, dynamic>;
                          final email = businessDoc.id;
                          final businessName =
                              business['name'] ?? ''; // Handle null value
                          final category = business['category'] ?? '';
                          final phoneNo = business['phone_no'] ?? '';
                          final operatingHours =
                              business['operating_hours'] ?? '';

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(businessName),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(category),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(phoneNo),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(operatingHours),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(email),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                buildActionWidget(context, businessDoc.id),
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

  Widget buildActionWidget(
    BuildContext context,
    String businessId,
  ) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.create),
          onPressed: () {
            navigateToUpdateBusinessScreen(context, businessId);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteBusiness(
              context,
              businessId,
            );
          },
        ),
      ],
    );
  }

  void navigateToCreateBusinessScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateBusinessScreen()),
    );
  }

  void navigateToUpdateBusinessScreen(BuildContext context, String businessId) {
    // TODO: Implement navigation to the update business screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateBusinessScreen(businessId)),
    );
  }

  void deleteBusiness(BuildContext context, String businessId) async {
    try {
      // Check if the business document exists.
      final businessDoc = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(businessId)
          .get();

      // If the business document does not exist, do not delete it.
      if (!businessDoc.exists) {
        print('Business document with ID $businessId does not exist.');
        return;
      }

      // TODO: Implement business deletion logic here

      // Delete business from Firestore
      await FirebaseFirestore.instance
          .collection('businesses')
          .doc(businessId)
          .delete();
      print('Deleted business with ID: $businessId');

      // Show a success message using FlutterToast.
      Fluttertoast.showToast(
        msg: 'The business has been deleted successfully.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue, // Set the background color to blue
        textColor: Colors.white,
      );

      // Optionally, navigate back to the businesses screen.
      // Navigator.pop(context);
    } catch (e) {
      print('Error deleting business: $e');
      // Show an error message using FlutterToast.
      Fluttertoast.showToast(
        msg: 'Failed to delete business. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class CreateBusinessScreen extends StatelessWidget {
  const CreateBusinessScreen({super.key});

  // TODO: Implement the UI and logic for creating a new business
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Business'),
      ),
      body: Center(
        child: Text('Implement the UI for creating a new business here.'),
      ),
    );
  }
}

class UpdateBusinessScreen extends StatefulWidget {
  final String businessId;

  const UpdateBusinessScreen(this.businessId, {Key? key}) : super(key: key);

  @override
  UpdateBusinessScreenState createState() => UpdateBusinessScreenState();
}

class UpdateBusinessScreenState extends State<UpdateBusinessScreen> {
  //final String businessId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();
  final TextEditingController _operating_hoursController =
      TextEditingController();

  //UpdateBusinessScreen();

  @override
  void initState() {
    super.initState();
    getBusinessDetails();
  }

  Future<void> getBusinessDetails() async {
    try {
      // Retrieve business details from Firestore using the provided businessId
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(widget.businessId)
          .get();

      if (snapshot.exists) {
        final business = snapshot.data() as Map<String, dynamic>;
        final String name = business['name'];
        final String category = business['category'];
        final String phone_no = business['phone_no'];
        final String operating_hours = business['operating_hours'];

        setState(() {
          _nameController.text = name;
          _categoryController.text = category;
          _phone_noController.text = phone_no;
          _operating_hoursController.text = operating_hours;
        });
      } else {
        // Business document with the provided businessId does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Business document with ID ${widget.businessId} does not exist.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pop(); // Go back to the previous screen
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error getting business details: $e');
      // Handle the error gracefully, show an error dialog, etc.
    }
  }

  void updateBusiness() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String category = _categoryController.text;
      final String phone_no = _phone_noController.text;
      final String operating_hours = _operating_hoursController.text;

      // TODO: Implement user update logic using Firestore
      updateBusinessInFirestore(name, category, phone_no, operating_hours);

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void updateBusinessInFirestore(
      String name, String category, String phone_no, String operating_hours) {
    FirebaseFirestore.instance
        .collection('businesses')
        .doc(widget.businessId)
        .update({
      'name': name,
      'category': category,
      'phone_no': phone_no,
      'operating_hours': operating_hours,
    });

    // Show a toast message to indicate that the business has been updated
    Fluttertoast.showToast(
      msg: 'Business updated successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    print('Business updated: name=$name');
  }

  // TODO: Implement the UI and logic for updating a business
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Business'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Business Name'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phone_noController,
                    decoration: InputDecoration(labelText: 'Phone No'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _operating_hoursController,
                    decoration: InputDecoration(labelText: 'Operating Hours'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 50, // Replace with your desired height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: updateBusiness,
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
