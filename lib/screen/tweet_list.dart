import 'package:active_edge/models/Tweet.dart';
import 'package:active_edge/models/User.dart';
import 'package:active_edge/repository/repository.dart';
import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/utils.dart';
import 'package:active_edge/widgets/TweetWidget.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import 'album_list.dart';

class TweetList extends StatefulWidget {
  @override
  _TweetListState createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = true;
  bool error = false;
  Repository _repo = Repository();
  Map<String, dynamic> _result = Map();
  List<Tweet> _users;

  @override
  void afterFirstLayout(BuildContext context) async {
    _result = await _repo.fetchTweets();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        _users = _result['tweets'] as List<Tweet>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width - 150;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("All Tweets"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),onPressed: (){
            _displayDialog(context);
          },)
        ],
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
          : ListView.builder(
              itemCount: _users.length,

              itemBuilder: (context, index) {
                final tweet = _users[index];
                return InkWell(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (_)=> AlbumList(userId: user.id,)));
                  },
                  child: Dismissible(
                    onDismissed: (direction){
                      _repo.deleteTweets(index).then((result){
                        setState(() {
                          _users.removeAt(index);
                        });
                        if(result['successful'] == true){

                          showInSnackBar("Tweet Deleted");
                        }else{
                          showInSnackBar("we could not delete this tweet, try again");
                        }
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.delete, color: Colors.white,),
                          Icon(Icons.delete, color: Colors.white,)
                        ],
                      ),
                    ),
                    child: InkWell(
                      onTap: (){
                        _displayUpdateDialog(context, tweet.body, index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                          children: <Widget>[
                            _getUserAvatar(tweet.email.substring(0, 2), ""),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(child: Text(tweet.body),width: size,),
                                Text("email: ${tweet.email}", style: TextStyle(color: Colors.blue),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ), key: Key(tweet.email),
                  ),
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

  _displayDialog(BuildContext context) async {
    String tweet1 = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: TweetInputSheet(),
          );
        });
    if(tweet1 != null && tweet1.length > 3){
      List<Tweet> tweet = [ Tweet( email: "ed@gmail.com", body: tweet1) ];
      tweet.addAll(_users);
      setState(() {
        _users = tweet;
      });
      _repo.postTweets(tweet.first).then((result){
        if(result['successful'] == true){
          showInSnackBar("Tweet Added");
        }else{
          showInSnackBar("we could not post your, try again");
        }
      });
    }
    //print("llllll ${double}");
  }

  _displayUpdateDialog(BuildContext context, String body, int index) async {
    String tweet1 = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: TweetInputSheet(body: body,),
          );
        });
    if(tweet1 != null && tweet1.length > 3){

      setState(() {
        _users[index].body = tweet1;
      });
      _repo.updateTweets(index, _users[index]).then((result){
        if(result['successful'] == true){
          showInSnackBar("Tweet Updated");
        }else{
          showInSnackBar("we could not update this tweet, try again");
        }
      });
    }
    //print("llllll ${double}");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleRetry() async{
    setState(() {
      _loading = true;
    });
    _result = await _repo.fetchTweets();
    setState(() {
      _loading = false;
    });
    if (_result['successful'] == false) {
    } else {
      setState(() {
        _users = _result['tweets'] as List<Tweet>;
      });
    }
  }
}
