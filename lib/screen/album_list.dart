import 'package:active_edge/models/album.dart';
import 'package:active_edge/models/User.dart';
import 'package:active_edge/repository/repository.dart';
import 'package:active_edge/screen/photo_list.dart';
import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class AlbumList extends StatefulWidget {
  final int userId;
  const AlbumList({Key key, this.userId}) : super(key: key);
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> with AfterLayoutMixin {
  bool _loading = true;
  Repository _repo = Repository();
  Map<String, dynamic> _result = Map();
  List<Album> _albums;
  bool error = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    _result = await _repo.fetchAlbums();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        if(widget.userId == null){
          _albums = (_result['albums'] as List<Album>);

        }else{
          _albums = (_result['albums'] as List<Album>).where((album) => album.userId == widget.userId).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width - 150;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Albums"),
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
              SvgPicture.asset("assets/images/sad.svg",height: 70,),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: Text(
                  "Sorry, We could not complete your request",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
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
           :ListView.separated(
              itemCount: _albums.length,
              itemBuilder: (context, index) {
                final album = _albums[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> PhotoList(albumId: album.id,)));

                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      children: <Widget>[
                        _getUserAvatar(album.title.substring(0, 2), ""),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(child: Text(album.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),), width: size,)
                      ],
                    ),
                  ),
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
    print("avatar url $avartarUrl");
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
    _result = await _repo.fetchAlbums();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        if(widget.userId == null){
          _albums = (_result['albums'] as List<Album>);

        }else{
          _albums = (_result['albums'] as List<Album>).where((album) => album.userId == widget.userId).toList();
        }
      });
    }
  }
}
