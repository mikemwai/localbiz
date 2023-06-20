import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/authentication.dart';
import 'signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalBiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Home Page',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 0),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black45),
                  ),
                  onPressed: () {
                    //sign out
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Authentication.signout(context: context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Signin()));
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign out',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
