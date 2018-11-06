import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import './splashscreen.dart';
import './profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:photo_view/photo_view.dart';

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
                    icon: new Icon(Icons.image),
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
                    icon: new Icon(Icons.video_library),
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
                new Flexible(
                  child: new TextField(
                    textInputAction: TextInputAction.newline,
                    decoration: new InputDecoration(hintText: 'enter message!'),
                    controller: _msg,
                  ),
                ),
                new IconButton(
                    icon: new Icon(Icons.send),
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
  ChatMessage(
      {this.text,
      this.email,
      this.pic,
      this.name,
      this.e,
      this.type,
      this.url});
  final String text, email, pic, name, e, type, url;

  @override
  Widget build(BuildContext context) {
    var x = Colors.green;
    if (email == e) {
      x = Colors.blue;
    }

    if (type == "image") {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
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
                new Container(
                  child: new Text(name, style: new TextStyle(color: x)),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(55.0, 10.0, 0.0, 0.0),
              height: 300.0,
                child: PhotoViewInline(
                  imageProvider: NetworkImage(url),
                )

            )
          ],
        ),
      );
    } else if (type == "video") {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
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
                new Container(
                  child: new Text(name, style: new TextStyle(color: x)),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(55.0, 10.0, 0.0, 0.0),
                child: new Chewie(
                  new VideoPlayerController.network(
                     url),
                  aspectRatio: 3 / 2,
                  looping: true,
                ))
          ],
        ),
      );
    }

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
              new Text(name, style: new TextStyle(color: x)),
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
