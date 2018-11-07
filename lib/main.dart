import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './splashscreen.dart';
import './profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_picker/contact_picker.dart';
import './single_message.dart';


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
      title: 'Schat',
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;
  String _email = "placeholder@gmail.com",
      _pic = "https://flutter.io/images/catalog-widget-placeholder.png",
      _name = "loading";
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
        title: new Text('Schat'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.attach_file),
            onPressed: () {
              _showDialog();
            },
          ),

          new IconButton(
            icon: new Icon(Icons.person),
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
                  e: _email,
                  type: snapshot.value['type'],
                  url: snapshot.value['url'],
                );
              },
            ),
          ),
          new Divider(height: 2.0),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Row(
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.camera,color: Colors.blue),
                    onPressed: () async {
                      File imageFile = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      int random = new Random().nextInt(100000);
                      StorageReference ref = FirebaseStorage.instance
                          .ref()
                          .child("image_$random.jpg");
                      StorageUploadTask uploadTask = ref.put(imageFile);
                      var dowurl = await (await uploadTask.onComplete)
                          .ref
                          .getDownloadURL();
                      print(dowurl.toString());
                      sendMsg("image", "image", dowurl.toString());
                    }),
                new Flexible(
                  child: new TextField(
                    textInputAction: TextInputAction.newline,
                    decoration: new InputDecoration(hintText: 'enter message!'),
                    controller: _msg,
                  ),
                ),
                new IconButton(
                    icon: new Icon(Icons.send,color: Colors.blue,),
                    onPressed: () {
                      sendMsg(_msg.text, "text", "text");
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

  sendMsg(String txt, String type, String url) {
    setState(() {
      reference.push().set({
        'text': txt,
        'type': type,
        'url': url,
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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
         title: new Text("Send"),
          content: new Text("Choose an action!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new IconButton(
                icon: new Icon(Icons.image,color: Colors.greenAccent),
                onPressed: () async {
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery);
                  int random = new Random().nextInt(100000);
                  StorageReference ref = FirebaseStorage.instance
                      .ref()
                      .child("image_$random.jpg");
                  StorageUploadTask uploadTask = ref.put(imageFile);
                  var dowurl = await (await uploadTask.onComplete)
                      .ref
                      .getDownloadURL();
                  print(dowurl.toString());
                  sendMsg("image", "image", dowurl.toString());
                }),
            new IconButton(
                icon: new Icon(Icons.video_library,color: Colors.blue),
                onPressed: () async {
                  File videoFile = await ImagePicker.pickVideo(
                      source: ImageSource.gallery);
                  int random = new Random().nextInt(100000);
                  StorageReference ref = FirebaseStorage.instance
                      .ref()
                      .child("video_$random.jpg");
                  StorageUploadTask uploadTask = ref.put(videoFile);
                  var dowurl = await (await uploadTask.onComplete)
                      .ref
                      .getDownloadURL();
                  print(dowurl.toString());
                  sendMsg("video", "video", dowurl.toString());
                }),
            new IconButton(
                icon: new Icon(Icons.contacts,color: Colors.purpleAccent,),
                onPressed: () async {

                  Contact contact = await _contactPicker.selectContact();
                  print(contact.toString());
                  sendMsg("contact", "contact", contact.toString());


                }),
            new IconButton(
                icon: new Icon(Icons.close,color: Colors.redAccent),
                onPressed: () {
                  Navigator.pop(context);
                })

          ],
        );
      },
    );
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

