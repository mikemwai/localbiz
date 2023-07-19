// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison, non_constant_identifier_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  //final String businessId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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

      setState(() {
        _emailController = email as TextEditingController;
      });
    }
  }

  /*Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        String email = user.email ?? ''; // Changed userEmail to email
      });
    }
  }*/

  void createOrder() async {
    if (_formKey.currentState!.validate()) {
      // Create a document reference in the "orders" collection.
      final documentReference =
          FirebaseFirestore.instance.collection('orders').doc();

      // Get the business details from the text controllers.
      final String price = _priceController.text;
      final String phoneNo = _phone_noController.text;
      final String email = _emailController.text;

      // Save the business details to Firestore.
      await documentReference.set({
        'price': price,
        'phone_no': phoneNo,
        'status': '',
        'email': email,
      });

      // Show a toast to indicate that the business profile has been added.
      Fluttertoast.showToast(
        msg: 'Order placed successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue, // Set the background color of the toast
        textColor: Colors.white, // Set the text color of the toast
        fontSize: 16.0,
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Business Owner Email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Total Price'),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 50, // Set the desired height
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phone_noController,
                    decoration: InputDecoration(labelText: 'Customer Phone No'),
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
                    onPressed: createOrder,
                    child: Text('Place Order'),
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

class OrderView extends StatefulWidget {
  const OrderView({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  OrderViewState createState() => OrderViewState();
}

class OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Extract user documents from the snapshot
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
                            label: Text('Price'),
                          ),
                          DataColumn(
                            label: Text('Phone Number'),
                          ),
                          DataColumn(
                            label: Text('Action'),
                          ),
                        ],
                        rows: orders.map((userDoc) {
                          final orders = userDoc.data() as Map<String, dynamic>;
                          final email = orders['email'];
                          final price = orders['price'];
                          final phone_no = orders['phone_no'];

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(email),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(price),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(phone_no),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                buildActionWidget(context, userDoc.id),
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
                userId: '',
              ), // Replace with your BusinessesScreen widget
            ),
          );
        },
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
                builder: (context) => UpdateOrder(
                  orderId:
                      orderId, // Pass the orderId to the UpdateOrder widget
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class UpdateOrder extends StatefulWidget {
  const UpdateOrder({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  UpdateOrderState createState() => UpdateOrderState();
}

class UpdateOrderState extends State<UpdateOrder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

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
        final String price = order['price'];
        final String phoneNo = order['phone_no'];
        final String status = order['status'];

        setState(() {
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
      final String price = _priceController.text;
      final String phoneNo = _phone_noController.text;
      final String status = _statusController.text;

      // TODO: Implement order update logic using Firestore
      await updateOrderInFirestore(price, phoneNo, status);

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
      String price, String phoneNo, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId) // Use the orderId to update the correct document
          .update({
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
