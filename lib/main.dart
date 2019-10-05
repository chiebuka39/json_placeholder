import 'package:active_edge/screen/artist_list.dart';
import 'package:active_edge/utils/Strings.dart';
import 'package:flutter/material.dart';

import 'utils/MyColors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: MyColors.colorPrimary,
          accentColor: MyColors.accentColor,
          buttonTheme: ButtonTheme.of(context).copyWith(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ArtistList()));
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: MyColors.otp,
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(children: <Widget>[
                    Text("Artist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),)
                  ],),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: MyColors.otp,
                    borderRadius: BorderRadius.circular(7)),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: MyColors.otp,
                    borderRadius: BorderRadius.circular(7)),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
