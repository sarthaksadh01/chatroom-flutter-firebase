import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './splashscreen.dart';
import './home.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Login', home: new LoginScreeen());
  }
}

class LoginScreeen extends StatefulWidget {
  @override
  LoginScreeenState createState() => LoginScreeenState();
}

class LoginScreeenState extends State<LoginScreeen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  String _email;
  String _password;
  TextEditingController _e, _p;

  @override
  void initState() {
    startTime();

    _e = new TextEditingController();
    _p = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlutterLogo(
            size: 130.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: new TextField(
              decoration: InputDecoration(
                  hintText: 'Email address',
                  icon: new Icon(Icons.email),
                  labelText: 'Email'),
              controller: _e,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
            child: new TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Paassword',
                    icon: new Icon(Icons.apps),
                    labelText: 'Password'),
                obscureText: true,
                controller: _p),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new MaterialButton(
                  height: 40.0,
                  minWidth: 120.0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: new Text("Login"),
                  onPressed: sign,
                  splashColor: Colors.redAccent,
                ),
                new MaterialButton(
                  height: 40.0,
                  minWidth: 120.0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: new Text("Register"),
                  onPressed: register,
                  splashColor: Colors.redAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  register() {
    setState(() {
      _email = _e.text;
      _password = _p.text;
    });

    handleSignUp(_email, _password).then((FirebaseUser user) {
      startTime();
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Error occured Try again!")));
      print("error is $e");
    });
  }

  sign() {
    setState(() {
      _email = _e.text;
      _password = _p.text;
    });

    handleSignIn(_email, _password).then((FirebaseUser user) {
      startTime();
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
              "Error occured make sure you entered correct details!")));
      print("error is $e");
    });
  }

  Future<FirebaseUser> handleSignIn(email, password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print("signed in " + user.uid);
    return user;
  }

  Future<FirebaseUser> handleSignUp(email, password) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("signed in " + user.uid);
    return user;
  }


  Future startTime() async {
    _user = await _auth.currentUser();
    if (_user != null) {
      print("user exist");
      Route route = MaterialPageRoute(builder: (context) => SecondScreen());
      Navigator.pushReplacement(context, route);
    } else
      print("not exist");
  }
}
