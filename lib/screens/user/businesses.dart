// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessesDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Businesses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final businesses = snapshot.data!.docs;
            return ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business =
                    businesses[index].data() as Map<String, dynamic>;
                final String name = business['name'] ?? '';
                final String category = business['category'] ?? '';
                final String phoneNo = business['phone_no'] ?? '';
                final String operatingHours = business['operating_hours'] ?? '';

                return BusinessCard(
                  name: name,
                  category: category,
                  phoneNo: phoneNo,
                  operatingHours: operatingHours,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class BusinessCard extends StatelessWidget {
  final String name;
  final String category;
  final String phoneNo;
  final String operatingHours;

  const BusinessCard({
    required this.name,
    required this.category,
    required this.phoneNo,
    required this.operatingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.business),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: $category'),
            Text('Phone Number: $phoneNo'),
            Text('Operating Hours: $operatingHours'),
          ],
        ),
      ),
    );
  }
}
