import 'dart:convert';

List<Tweet> tweetFromJson(String str) => List<Tweet>.from(json.decode(str).map((x) => Tweet.fromJson(x)));

String tweetToJson(List<Tweet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tweet {
  int postId;
  int id;
  String name;
  String email;
  String body;

  Tweet({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) => Tweet(
    postId: json["postId"],
    id: json["id"],
    name: json["name"],
    email: json["email"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "id": id,
    "name": name,
    "email": email,
    "body": body,
  };
}