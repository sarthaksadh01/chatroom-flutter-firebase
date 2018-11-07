import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:photo_view/photo_view.dart';
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
                  autoInitialize: true,
                  looping: true,
                ))
          ],
        ),
      );
    }
    else if(type=="text"){
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

    else if(type == 'contact'){
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
                  child: new InkWell(
                  child: new Text("Call - $url",style: new TextStyle(
                    color: Colors.brown
                  ),),
                  onTap: ()  => {

                  }),
    ),
              ],
            ),
          ],
        ),
      );
    }
    else if(type == 'location'){
      var location = url.split('@');
      String latitude =location[0],longitude=location[1];
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
                  imageProvider: NetworkImage( "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=18&size=640x400&key=YOUR_API_KEY"),
                )

            )
          ],
        ),
      );
    }
    else{
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
                  child: new Text("Please update your app to see this content!"),
                ),
              ],
            ),
          ],
        ),
      );
    }


  }
}
