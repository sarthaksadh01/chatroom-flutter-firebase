import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Login', home: new ProfileScreen());
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String _name = "loading",
      _email = "loading",
      _pic = "https://flutter.io/images/catalog-widget-placeholder.png";
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    getCredential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: new Container(
              child: new Image.network(
                _pic.toString(),
                height: 130.0,
                width: 100.0,
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(20.0),
            child: new Text(_name.toString(),
                style: new TextStyle(fontSize: 25.0, color: Colors.blue)),
          ),
          new Container(
            padding: EdgeInsets.all(20.0),
            child: new Text(
              _email.toString(),
              style: new TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
//          new Container(
//              padding: EdgeInsets.all(20.0),
//              child: new RaisedButton(
//                onPressed: () {
//                  clearUser();
//                },
//                color: Colors.blue,
//                child: new Text('Logout'),
//              )),
        ],
      ),
    );
  }

  clearUser() async{
    sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _name = sharedPreferences.getString("name");
      _email = sharedPreferences.getString("email");
      _pic = sharedPreferences.getString("pic");
    });
  }
}
