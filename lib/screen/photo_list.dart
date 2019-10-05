import 'package:active_edge/models/album.dart';
import 'package:active_edge/models/User.dart';
import 'package:active_edge/models/photo.dart';
import 'package:active_edge/repository/repository.dart';
import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class PhotoList extends StatefulWidget {
  final int albumId;
  const PhotoList({Key key, this.albumId}) : super(key: key);
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> with AfterLayoutMixin {
  bool _loading = true;
  bool error = false;
  Repository _repo = Repository();
  Map<String, dynamic> _result = Map();
  List<Photo> _photos;

  @override
  void afterFirstLayout(BuildContext context) async {
    _result = await _repo.fetchPhotos(widget.albumId);
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        _photos = (_result['photos'] as List<Photo>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("photos length ${_photos.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Artist Photos"),
      ),
      body: _loading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(MyColors.colorPrimary),
                ),
              ),
            )
          : error == true
          ? Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              SvgPicture.asset("assets/images/sad.svg", height: 70,),
              SizedBox(
                height: 20,
              ),
              Text(
                "Sorry, We could not complete your request",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 150,
                height: 45,
                child: RaisedButton(
                  color: MyColors.otp,
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _handleRetry,
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      )
          : ListView.separated(
              itemCount: _photos.length - 30,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return Container(
                  height: 170,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(imageUrl: photo.url,fit: BoxFit.fill,),
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                );
              },
            ),
    );
  }

  Widget _getUserAvatar(String placeholder, String avartarUrl) {
    //print("avatar url $avartarUrl");
    var placeHolder = new Center(
      child: new Text(
        placeholder.toUpperCase(),
        style: new TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
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

  void _handleRetry() async{
    setState(() {
      _loading = true;
    });
    _result = await _repo.fetchPhotos(widget.albumId);
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        _photos = (_result['photos'] as List<Photo>);
      });
    }
  }
}
