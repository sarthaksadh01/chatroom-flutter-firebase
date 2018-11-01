import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            logout(context);
            // Navigate back to first screen when tapped!
          },
          child: Text('Log out!'),
        ),
      ),
    );
  }

  logout(BuildContext context) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final Future<FirebaseUser> user =auth.currentUser();

//    await auth.signOut();
    print(user);
//    Navigator.pop(context);
  }
}
