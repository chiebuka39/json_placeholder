import 'package:active_edge/utils/MyColors.dart';
import 'package:active_edge/utils/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TweetInputSheet extends StatefulWidget {
  final String body;
  TweetInputSheet({this.body = ""});

  @override
  _TweetInputSheetState createState() => _TweetInputSheetState();
}

class _TweetInputSheetState extends State<TweetInputSheet> {
  String error;
  String _tweet;
  TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(text: widget.body);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 400,
      width: 300,
      child: new Column(

        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10,),
          const Text(
            'Enter your tweet',
            style: const TextStyle(
                color: MyColors.colorPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: new TextField(
              controller: controller,
              maxLines: null,
              onChanged: onAmountChange,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: MyColors.colorPrimary)),
                  labelText: 'Enter your tweet',

                  errorMaxLines: 3,
                  errorText: error),
              style: new TextStyle(color: MyColors.colorPrimary, fontSize: 15.0),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: new SizedBox(
              width: double.infinity,
              child: new RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop(_tweet);
                },
                color: MyColors.otp,
                padding: EdgeInsets.symmetric(vertical: 14),
                child: new Text(
                  widget.body.isEmpty ? 'Tweet' : 'Update Tweet',
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  void onAmountChange(String value) {
    var ans = validateTwwet(value);

    setState(() {
      error = ans;
      _tweet = value == null ? null:value;
    });
  }

  String validateTwwet(String value) {
    if (value.isEmpty) {
      return Strings.fieldReq;
    }

    if (value.length < 3 ) {
      return "Tweet should be greater than 3 characters";
    }
    return null;
  }
}