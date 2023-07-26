// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localbiz1/screens/admin.dart';
import 'package:localbiz1/screens/admin/adminprofile_screen.dart';
import 'package:localbiz1/screens/admin/businesses.dart';
import 'package:localbiz1/screens/admin/orders.dart';
import 'package:localbiz1/screens/admin/profile_screen1.dart';
import 'package:localbiz1/screens/businessowner/orders.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/utils/authentication.dart';

class PaymentsAdmin extends StatefulWidget {
  const PaymentsAdmin({Key? key, required this.userId, required this.userEmail})
      : super(key: key);

  final String userId;
  final String userEmail;

  @override
  PaymentsAdminState createState() => PaymentsAdminState();
}

class PaymentsAdminState extends State<PaymentsAdmin> {
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? ''; // Changed userEmail to email
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('payments')
            .snapshots(), // Retrieve all orders from the "orders" collection
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract order documents from the snapshot
          final payments = snapshot.data!.docs;

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
                            label: Text('Phone No'),
                          ),
                          DataColumn(
                            label: Text('Amount (Ksh)'),
                          ),
                          DataColumn(
                            label: Text('Action'),
                          ),
                        ],
                        rows: payments.map((orderDoc) {
                          final payments =
                              orderDoc.data() as Map<String, dynamic>;
                          final phone_no = payments['phone_no'] ??
                              'N/A'; // Handle null value with a default value of 0
                          final amount = payments['amount'] ??
                              'N/A'; // Handle null value with a default 'N/A'

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(phone_no),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(amount.toString()),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                buildActionWidget(context, orderDoc.id),
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

  Widget buildActionWidget(BuildContext context, String orderId) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.create),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdatePaymentsAdmin(
                  orderId:
                      orderId, // Pass the orderId to the UpdateOrder widget
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deletePayments(context, orderId);
          },
        ),
      ],
    );
  }
}

void _deletePayments(BuildContext context, String orderId) async {
  try {
    // Check if the order document exists.
    final userDoc = await FirebaseFirestore.instance
        .collection('payments')
        .doc(orderId)
        .get();

    // If the user document does not exist, show an error message and return.
    if (!userDoc.exists) {
      Fluttertoast.showToast(
        msg: 'Payment document with ID $orderId does not exist.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Delete order document from Firestore.
    try {
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(orderId)
          .delete();
      print('Deleted payment with ID: $orderId from Firestore.');
    } catch (e) {
      // Handle the exception for Firestore.
      Fluttertoast.showToast(
        msg: 'Failed to delete payment from Firestore. Please try again.',
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
      msg: 'The payment has been deleted successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    // Optionally, you can navigate back to the user screen here if needed.
    //Navigator.pop(context);
  } catch (e) {
    print('Error deleting payment: $e');
    // Show an error message using FlutterToast.
    Fluttertoast.showToast(
      msg: 'Failed to delete payment. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

class UpdatePaymentsAdmin extends StatefulWidget {
  const UpdatePaymentsAdmin({Key? key, required this.orderId})
      : super(key: key);

  final String orderId;

  @override
  UpdatePaymentState createState() => UpdatePaymentState();
}

class UpdatePaymentState extends State<UpdatePaymentsAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPaymentDetails();
  }

  void getPaymentDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.orderId)
          .get();

      if (snapshot.exists) {
        final order = snapshot.data() as Map<String, dynamic>;
        final double price = order['amount'];
        final String phoneNo = order['phone_no'];

        setState(() {
          _priceController.text = price.toString();
          _phone_noController.text = phoneNo;
        });
      }
    } catch (e) {
      print('Error getting order details: $e');
    }
  }

  void _updatePayment() async {
    if (_formKey.currentState!.validate()) {
      final String price = _priceController.text;
      final String phoneNo = _phone_noController.text;

      // TODO: Implement order update logic using Firestore
      await updatePaymentInFirestore(price, phoneNo);

      Fluttertoast.showToast(
        msg: 'Payment updated!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    }
  }

  Future<void> updatePaymentInFirestore(String price, String phoneNo) async {
    try {
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(widget.orderId) // Use the orderId to update the correct document
          .update({
        'amount': price,
        'phone_no': phoneNo,
      });
      print('payment updated!');
    } catch (e) {
      print('Error updating payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Payment'),
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
                    controller: _phone_noController,
                    decoration: InputDecoration(
                        labelText: "Recipient's Phone Number (254..)"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Total Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the total price';
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
                    onPressed: _updatePayment,
                    child: Text('Update Payment'),
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
