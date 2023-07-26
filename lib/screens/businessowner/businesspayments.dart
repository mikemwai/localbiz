// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localbiz1/screens/businessowner.dart';
import 'package:localbiz1/screens/businessowner/orders.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/utils/authentication.dart';
import 'package:mpesa/mpesa.dart';

class BusinessPayments extends StatefulWidget {
  const BusinessPayments({super.key});

  @override
  _BusinessPaymentsState createState() => _BusinessPaymentsState();
}

class _BusinessPaymentsState extends State<BusinessPayments> {
  Mpesa _mpesa = Mpesa(
    clientKey: "dIsQlT3H7xBtt9Ai0vQkIH6u1Rw7Qx5D",
    clientSecret: "0Vl8WmfhBs5HgBVQ",
    passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
    environment: "sandbox",
  );

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  bool isDrawerOpen = false;
  String email = ''; // Changed userEmail to email

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
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
        email = user.email ?? ''; // Changed userEmail to email
      });
    }
  }

  void _handleSubmit() {
    String phoneNumber = _phoneController.text;
    double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (phoneNumber.isNotEmpty && amount > 0) {
      // Save order details to Firestore
      FirebaseFirestore.instance.collection("payments").add({
        "phone_no": phoneNumber,
        "amount": amount,
      }).then((result) {
        // Handle success
      }).catchError((error) {
        // Handle error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments Page'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 80.0, // Set the desired height for the SizedBox
                width: MediaQuery.of(context).size.width *
                    0.70, // Set the desired width here
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Recipient's Phone Number (254...)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 80.0, // Set the desired height for the SizedBox
                width: MediaQuery.of(context).size.width *
                    0.70, // Set the desired width here
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Total Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.65, // Set the desired width here7
                height: 50.0, // Set the desired height for the SizedBox
                child: ElevatedButton(
                  child: Text("Prompt User to Pay"),
                  onPressed: () {
                    double amount =
                        double.tryParse(_amountController.text) ?? 0.0;
                    _mpesa.lipaNaMpesa(
                      phoneNumber: _phoneController.text,
                      amount: amount, // Pass the 'double' value here
                      businessShortCode: "174379",
                      callbackUrl: "https://mydomain.com/path",
                    );
                    _handleSubmit(); // Call the _handleSubmit function here
                  },
                ),
              ),
            ],
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
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  size: 64,
                  color: Colors.blue,
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
                email, // Changed userEmail to email
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Business Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessOwner(),
                  ),
                );
              },
            ),
            /*const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: const Text('Products'),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Order(),
                  ),
                );
              },*/
            ),*/
            const Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: const Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderView(
                      userEmail: '',
                      userId: '',
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessPayments(),
                  ),
                );
              },
            ),
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
