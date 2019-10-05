
import 'package:active_edge/models/Tweet.dart';
import 'package:active_edge/models/User.dart';
import 'package:active_edge/models/album.dart';
import 'package:active_edge/models/photo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
class Repository{
  static final Repository instance = new Repository._internal();

  factory Repository() => instance;
  // private, named constructor
  Repository._internal();
  var baseUrl = "https://jsonplaceholder.typicode.com";


  Future<Map<String, dynamic>> fetchUsers() async {

    Map<String, dynamic> result = Map();


    print("$baseUrl/user");
    try{
      final response = await http.get('$baseUrl/users',).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching User details";
      }else {
          result['successful'] = true;
          result['users'] = userFromJson( response.body) ;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }

  Future<Map<String, dynamic>> fetchAlbums() async {

    Map<String, dynamic> result = Map();


    print("$baseUrl/albums");
    try{
      final response = await http.get('$baseUrl/albums',).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching albums list";
      }else {
        result['successful'] = true;
        result['albums'] = albumFromJson( response.body) ;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }
  Future<Map<String, dynamic>> fetchPhotos(int albumId) async {

    Map<String, dynamic> result = Map();


    print("$baseUrl/albums");
    try{
      final response = await http.get('$baseUrl/albums/1/photos',).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching albums list";
      }else {
        result['successful'] = true;
        List<Photo> photos = photoFromJson( response.body).where((photo) => photo.albumId == albumId).toList();
        result['photos'] =  photos;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }
  Future<Map<String, dynamic>> fetchTweets() async {
    Map<String, dynamic> result = Map();

    print("$baseUrl/comments?_start=0&_limit=30");
    try{
      final response = await http.get('$baseUrl/comments?_start=0&_limit=30',).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching albums list";
      }else {
        result['successful'] = true;
        List<Tweet> tweets = tweetFromJson( response.body);
        result['tweets'] =  tweets;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }
  Future<Map<String, dynamic>> postTweets(Tweet tweet) async {
    Map<String, dynamic> result = Map();


    //print("$baseUrl/comments?_start=0&_limit=30");
    try{
      final response = await http.post('$baseUrl/comments',body: tweet.toJson()).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while posting tweets";
      }else {
        result['successful'] = true;


      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }
  Future<Map<String, dynamic>> updateTweets(int commentId, Tweet tweet) async {
    Map<String, dynamic> result = Map();

    print("$baseUrl/comments?_start=0&_limit=30");
    try{
      final response = await http.put('$baseUrl/comments/$commentId',body: tweet.toJson()).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching albums list";
      }else {
        result['successful'] = true;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteTweets(int tweetId) async {
    Map<String, dynamic> result = Map();

    //print("$baseUrl/comments?_start=0&_limit=30");
    try{
      final response = await http.delete('$baseUrl/comments/$tweetId',).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      //print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching albums list";
      }else {
        result['successful'] = true;

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    print("the result is $result");
    return result;
  }


}