import 'package:active_edge/models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
class Repository{
  var baseUrl = "https://jsonplaceholder.typicode.com/user";


  Future<Map<String, dynamic>> fetchCards({String token}) async {
    print("get cards");
    Map<String, dynamic> result = Map();

    var headers = {'Authorization': token};

    print("$baseUrl/user");
    try{
      final response = await http.get('$baseUrl/user', headers: headers).timeout(Duration(seconds: 15));

      final int statusCode = response.statusCode;
      print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        result['successful'] = false;
        result['error'] = "Error while fetching User details";
      }else {
          result['successful'] = true;
          result['users'] = userFromJson( jsonDecode(response.body) );

      }
    }catch(e){
      result['successful'] = false;
      result['error'] = e.toString();
    }
    return result;
  }


}