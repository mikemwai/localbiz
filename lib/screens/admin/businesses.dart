// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessesScreen extends StatelessWidget {
  const BusinessesScreen({Key? key}) : super(key: key);

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
                            label: Text('Email'),
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
                        ],
                        rows: businesses.map((businessDoc) {
                          final business =
                              businessDoc.data() as Map<String, dynamic>;
                          final businessName =
                              business['Name'] ?? ''; // Handle null value
                          final email = business['Email'] ?? '';
                          final category = business['Category'] ?? '';
                          final phoneNo = business['Phone_no'] ?? '';
                          final operatingHours =
                              business['OperatingHours'] ?? '';
                          final image =
                              business['Image'] ?? ''; // Handle null value

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(businessName),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(email),
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
          // TODO: Implement create business functionality
          navigateToCreateBusinessScreen(context);
        },
      ),
    );
  }

  Widget buildActionWidget(BuildContext context, String businessId,
      String businessName, String location) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.create),
          onPressed: () {
            navigateToUpdateBusinessScreen(
                context, businessId, businessName, location);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteBusiness(
                context, businessId); // Pass the BuildContext parameter
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

  void navigateToUpdateBusinessScreen(BuildContext context, String businessId,
      String businessName, String location) {
    // TODO: Implement navigation to the update business screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UpdateBusinessScreen(businessId, businessName, location)),
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

      // Navigate back to the businesses screen
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting business: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete business. Please try again.'),
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

class CreateBusinessScreen extends StatelessWidget {
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

class UpdateBusinessScreen extends StatelessWidget {
  final String businessId;
  final String businessName;
  final String location;

  UpdateBusinessScreen(this.businessId, this.businessName, this.location);

  // TODO: Implement the UI and logic for updating a business
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Business'),
      ),
      body: Center(
        child: Text('Implement the UI for updating the business here.'),
      ),
    );
  }
}
