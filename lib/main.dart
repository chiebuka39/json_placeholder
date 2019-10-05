import 'package:active_edge/screen/album_list.dart';
import 'package:active_edge/screen/artist_list.dart';
import 'package:active_edge/screen/tweet_list.dart';
import 'package:active_edge/utils/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'utils/MyColors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: MyColors.otp,
          accentColor: MyColors.accentColor,
          buttonTheme: ButtonTheme.of(context).copyWith(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          fontFamily: Strings.customFont),
      title: 'Active Edge',
      home: MyHomePage(title: 'Home Screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 150,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Hello \n", style: TextStyle(fontSize: 20)),
                        TextSpan(text: "Edwin,", style: TextStyle(fontSize: 45)),
                      ]))),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ArtistList()));
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: MyColors.otp,
                      borderRadius: BorderRadius.circular(7)),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Artist",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        "assets/images/greek.svg",
                        height: 50,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => TweetList()));
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Tweets",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        "assets/images/twitter.svg",
                        height: 50,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: MyColors.otp,
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
