// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/authentication.dart';
import 'signin.dart';

class BusinessOwner extends StatefulWidget {
  const BusinessOwner({Key? key}) : super(key: key);

  @override
  State<BusinessOwner> createState() => _BusinessOwnerState();
}

class _BusinessOwnerState extends State<BusinessOwner> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO: Google Maps Interface
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
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
                'owner@example.com',
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
              title: const Text('Business Profile'),
              onTap: () {
                // TODO: Implement the navigation to the business profile screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Products'),
              onTap: () {
                // TODO: Implement the navigation to the products screen
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
