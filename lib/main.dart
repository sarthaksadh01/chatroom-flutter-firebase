import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './splashscreen.dart';
import './profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
  ));
}

final reference = FirebaseDatabase.instance.reference().child('messages');

class Schat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ChatRoom',
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _email = "placeholder@gmail.com",_pic="https://flutter.io/images/catalog-widget-placeholder.png",_name="loading";
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    getCredential();
    super.initState();
  }

  final TextEditingController _msg = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chatroom'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.account_circle),
            onPressed: () {
              profile(context);
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: reference,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation, int) {
                return new ChatMessage(
                  text: snapshot.value['text'],
                  email: snapshot.value['senderEmail'],
                  pic: snapshot.value['pic'],
                  name: snapshot.value['name'],
                  e:_email
                );
              },
            ),
          ),
          new Divider(height: 2.0),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    decoration: new InputDecoration(hintText: 'enter message!'),
                    controller: _msg,
                  ),
                ),
                new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () {
                      sendMsg(_msg.text);
                      _msg.clear();
//
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  sendMsg(String txt) {
    setState(() {
      reference.push().set({
        'text': txt,
        'senderEmail': _email,
        'name': _name,
        'pic': _pic,
        'time': new DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  profile(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => Profile());
    Navigator.push(context, route);
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

// single message template---------------------//

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.email, this.pic, this.name,this.e});
  final String text, email, pic, name,e;

  @override
  Widget build(BuildContext context) {
    var x= Colors.green;
    print(e);
    if(email==e){
      x=Colors.blue;
    }
    else x =Colors.red;
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(30.0),
              child: new CircleAvatar(
                child: Image.network(pic),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name, style: new TextStyle(
                color: x
              )),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
