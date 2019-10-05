import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArtistList extends StatefulWidget {
  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> with AfterLayoutMixin {

  bool _loading;

  @override
  void afterFirstLayout(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Artiste"),
      ),
      body: ListView.separated(
        itemCount: 2,
          itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 20,right: 20, top: 20 ),
          child: Row(
            children: <Widget>[
              _getUserAvatar("AE", ""),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text("Chiebuka Edwin"),
                Text("@eddy")
              ],)
            ],
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          );
      },),
    );
  }

  Widget _getUserAvatar(String placeholder, String avartarUrl) {
    var placeHolder = new Center(
      child: new Text(
        placeholder.toUpperCase(),
        style: new TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
    var avatarIsValid = avartarUrl.length > 40;
    return avatarIsValid
        ? Row(
            children: <Widget>[
              ClipOval(
                clipper: CircleClipper(),
                child: new CachedNetworkImage(
                  imageUrl: avartarUrl,
                  placeholder: (context, url) => placeHolder,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )
        : new Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.colorPrimaryDark,
            ),
            child: placeHolder,
          );
  }
}
