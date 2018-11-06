import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './main.dart';
import 'package:shared_preferences/shared_preferences.dart';




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
  final googleSignIn = new GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: new FlutterLogo(
                  size: 130.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: new MaterialButton(
                  height: 40.0,
                  minWidth: 120.0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: new Text("Join Schat!"),
                  onPressed: _ensureLoggedIn,
                  splashColor: Colors.redAccent,
                ),
              ),
            ]));
  }



  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null)
      await googleSignIn.signIn().then((account) {

        user = account;
        _SaveDetails(user.displayName,user.email,user.photoUrl);
      }, onError: (error) {
        print(error);
      }).whenComplete((){
        print(user.email);
        _SaveDetails(user.displayName,user.email,user.photoUrl);


      });
    else {
      Route route = MaterialPageRoute(builder: (context) => Schat());
      Navigator.pushReplacement(context, route);
      print(user);
    }
  }

  _SaveDetails(String name,String email,String pic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("pic", pic);
    prefs.commit();
    print("done");
  }


  }



