// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localbiz1/screens/admin.dart';
import 'package:localbiz1/screens/admin/adminprofile_screen.dart';
import 'package:localbiz1/screens/admin/businesses.dart';
import 'package:localbiz1/screens/admin/payments.dart';
import 'package:localbiz1/screens/admin/profile_screen1.dart';
import 'package:localbiz1/screens/businessowner/orders.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/utils/authentication.dart';

class OrdersAdmin extends StatefulWidget {
  const OrdersAdmin({Key? key, required this.userId, required this.userEmail})
      : super(key: key);

  final String userId;
  final String userEmail;

  @override
  OrderAdminState createState() => OrderAdminState();
}

class OrderAdminState extends State<OrdersAdmin> {
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
                          DataColumn(
                            label: Text('Action'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersScreen(
                userId: widget.userId,
              ), // Replace with your BusinessesScreen widget
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
                builder: (context) => UpdateOrdersAdmin(
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
            _deleteOrder(context, orderId);
          },
        ),
      ],
    );
  }
}

void _deleteOrder(BuildContext context, String orderId) async {
  try {
    // Check if the order document exists.
    final userDoc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();

    // If the user document does not exist, show an error message and return.
    if (!userDoc.exists) {
      Fluttertoast.showToast(
        msg: 'Order document with ID $orderId does not exist.',
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
          .collection('orders')
          .doc(orderId)
          .delete();
      print('Deleted order with ID: $orderId from Firestore.');
    } catch (e) {
      // Handle the exception for Firestore.
      Fluttertoast.showToast(
        msg: 'Failed to delete order from Firestore. Please try again.',
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
      msg: 'The order has been deleted successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    // Optionally, you can navigate back to the user screen here if needed.
    //Navigator.pop(context);
  } catch (e) {
    print('Error deleting order: $e');
    // Show an error message using FlutterToast.
    Fluttertoast.showToast(
      msg: 'Failed to delete order. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

class UpdateOrdersAdmin extends StatefulWidget {
  const UpdateOrdersAdmin({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  UpdateOrderState createState() => UpdateOrderState();
}

class UpdateOrderState extends State<UpdateOrdersAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getOrderDetails();
  }

  void getOrderDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (snapshot.exists) {
        final order = snapshot.data() as Map<String, dynamic>;
        final String email = order['email'];
        final String price = order['price'];
        final String phoneNo = order['phone_no'];
        final String status = order['status'];

        setState(() {
          _emailController.text = email;
          _priceController.text = price;
          _phone_noController.text = phoneNo;
          _statusController.text = status;
        });
      }
    } catch (e) {
      print('Error getting order details: $e');
    }
  }

  void _updateOrder() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String price = _priceController.text;
      final String phoneNo = _phone_noController.text;
      final String status = _statusController.text;

      // TODO: Implement order update logic using Firestore
      await updateOrderInFirestore(email, price, phoneNo, status);

      Fluttertoast.showToast(
        msg: 'Order updated!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      Navigator.pop(context);
    }
  }

  Future<void> updateOrderInFirestore(
      String email, String price, String phoneNo, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId) // Use the orderId to update the correct document
          .update({
        'email': email,
        'price': price,
        'phone_no': phoneNo,
        'status': status,
      });
      print('Order updated!');
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Order'),
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
                    decoration: InputDecoration(labelText: 'Business Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Total Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the total price';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phone_noController,
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
                  child: TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(
                        labelText: 'Status (Not Paid, Paid, Delivered)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the status';
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
                    onPressed: _updateOrder,
                    child: Text('Update Order'),
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
