import 'package:custom_splash_screen/custom_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String _name ="debug";
  SharedPreferences sharedPreferences;
  var x = 1;
  @override
  void initState() {
    getCredential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     if(_name!=null && _name !="debug"){
       return new CustomSplashScreen(
         errorSplash: errorSplash(),
         backgroundColor: Colors.white,
         loadingSplash: loadingSplash(),
         seconds: 5,
         navigateAfterSeconds: new Schat(),
       );
     }

     else{
       return new CustomSplashScreen(
         errorSplash: errorSplash(),
         backgroundColor: Colors.white,
         loadingSplash: loadingSplash(),
         seconds: 5,
         navigateAfterSeconds: new Login(),
       );
     }
  }

  Widget errorSplash() {
    return Center(
      child: Text(
        "Error Connecting.....",
        style: TextStyle(fontSize: 25.0, color: Colors.red),
      ),
    );
  }

  Widget loadingSplash() {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                flex: 2,
                child: new Container(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: new Container(
                        child: Image.network(
                            'https://flutter.io/images/catalog-widget-placeholder.png'),
                      ),
                      radius: 100.0,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text("wellcome to S Chat")
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    Text("Loading",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    new Center(
                      child: Text("Now",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getCredential() async {
     sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _name=sharedPreferences.getString("name");
      print(_name);

    });
  }

}


