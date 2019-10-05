import 'package:active_edge/models/User.dart';
import 'package:active_edge/repository/repository.dart';
import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import 'album_list.dart';

class ArtistList extends StatefulWidget {
  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> with AfterLayoutMixin {
  bool _loading = true;
  Repository _repo = Repository();
  Map<String, dynamic> _result = Map();
  List<User> _users;
  bool error = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    _result = await _repo.fetchUsers();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
      setState(() {
        error = false;
      });
    } else {
      setState(() {
        _users = _result['users'] as List<User>;
      });
    }
  }

  handleRetry() async {
    setState(() {
      _loading = true;
    });
    _result = await _repo.fetchUsers();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
      setState(() {
        error = false;
      });
    } else {
      setState(() {
        _users = _result['users'] as List<User>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Artiste"),
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
                            onPressed: handleRetry,
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
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AlbumList(
                                      userId: user.id,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: <Widget>[
                            _getUserAvatar(user.username.substring(0, 2), ""),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "@${user.username}",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )
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
}
